# Controller for all Bank API related actions.
class API::BankAccountController < ApplicationController
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
			render :json => {}, status: :not_found
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
end