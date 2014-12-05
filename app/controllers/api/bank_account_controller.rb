# = bank_account_controller.rb
#
# Controller for all Bank API related actions.
class API::BankAccountController < ApplicationController
	before_action :authenticate_client!, only: [:multi_transfer]

	respond_to :json

	require 'net/http'

	# Permited params for payment creation.
	def pago_params
		params.require(:payment).permit(:id_cuenta_banco, :detalle, :fecha_pago, :rut_cliente, :email)
	end

	# Forwards the Bank API response to client application as JSON.
	def show
		uri = URI.parse("http://204.87.169.110/accounts/" + params[:account])
		res = Net::HTTP.get_response(uri)

		if res.code == '200'
			render :json => JSON.parse(res.body)
		else
			render :json => {}, status: res.code
		end
	end

	# Performs the transfer API call and create a payment instance. If anything fails, a rollback is done. Returns the
	# new payment as JSON to the client.
	def transfer
	 	uri = URI.parse("http://204.87.169.110/transfer/"+params[:origin].to_s+"/"+params[:destination].to_s+"/"+params[:amount].to_s)
		rollback_uri = URI.parse("http://204.87.169.110/transfer/"+params[:destination].to_s+"/"+params[:origin].to_s+"/"+params[:amount].to_s)
		res = Net::HTTP.get_response(uri)
		if res.code == '200'
			# Transaction successfull
			@pago = Pago.new(pago_params)
			@cuentas = Cuenta.find_by :id_cuenta => params[:bill]
			@pago.cuentas << @cuentas
			if @pago.save
        		# Send email
        		UserMailer.payment_email(@pago, params[:payment][:email] ).deliver
				# Returns JSON
				render :json => @pago, status: :ok
			else
				# Rollback
				res = Net::HTTP.get_response(rollback_uri)
				if res.code == '200'
					render :json => {}, status: :internal_server_error
				end
			end
		else
			# Transaction unsuccessfull
			render :json => {}, status: :not_found
		end 
	end

	# Performs multiple money transfer and stores the details as a Pago instance.
	def multi_transfer
		@account = Account.find_by(:id_cuenta_banco => params[:account])
		if @account.funds >= Integer(params[:total])
			rollback_uris = []
			@pago = Pago.new(pago_params)
			params[:bills].each do |bill|
				@cuenta = Cuenta.find_by :id_cuenta => bill["id_cuenta"]
				if @cuenta.pago
					rollback_transfer(rollback_uris)
					render :json => {error: "Una de las cuentas ya se encuentra pagada."}, status: :precondition_failed and return
				end

				uri = URI.parse("http://204.87.169.110/transfer/"+ params[:account].to_s+ "/"+ bill["empresa"]["cuenta_banco"].to_s + "/" + bill["monto"].to_s)
				res = Net::HTTP.get_response(uri)

				if res.code == '200'
					@pago.cuentas << @cuenta
					rollback_uris << URI.parse("http://204.87.169.110/transfer/"+ bill["empresa"]["cuenta_banco"].to_s + "/" + params[:account].to_s + "/" + bill["monto"].to_s)
				else
					# Rollback money transfers
					rollback_transfer(rollback_uris)
					render :json => {error: "La transacción con el banco no se pudo realizar."}, status: :internal_server_error and return
				end
			end

			if @pago.save
				# Send email
	        	UserMailer.payment_email(@pago, params[:payment][:email] ).deliver
				# Returns JSON
				render :json => current_client, :include => [{:pagos => {:include => [{:cuentas => {:include => [:empresa]}}]}}, :accounts, {:unpaid_bills => {:include => [:empresa]}}], status: :ok
			else
				# Rollback money transfers
				rollback_transfer(rollback_uris)
				render :json => {error: "Ha ocurrido un error. Intente más tarde."}, status: :internal_server_error
			end
		else
			render :json => {error: "Los fondos de la cuenta seleccionada son insuficientes."}, status: :precondition_failed
		end
	end

	# Recursive method that performs a money transfer for each bill in 'uris', canceling the payment.
	def rollback_transfer(uris)
		failed_transfers = []
		uris.each do |uri|
			res = Net::HTTP.get_response(uri)
			if res.code != '200'
				failed_transfers << uri
			end
		end
		if failed_transfers.length > 0
			return rollback_transfer(failed_transfers)
		else
			return true
		end
	end
end
