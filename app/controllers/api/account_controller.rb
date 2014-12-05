# = account_controller.rb
#
# Controller class for all Account related actions.
class API::AccountController < ApplicationController
	# Only Clients can create and destroy accounts.
  	before_action :authenticate_client!, only: [:create, :destroy]

  	# Responds to and with JSON.
	respond_to :json

	require 'net/http'

	# Permited params to bill creation.
	def account_params
		params.require(:account).permit(:id_cuenta_banco, :rut)
	end

	# Not necessary
	def index
    	render :json => {}, status: :method_not_allowed
	end

  # Mirror external API for same-origin policy purposes.
	def show
      render :json => {}, status: :method_not_allowed
	end

	# Creates a bill.
	def create
		uri = URI.parse("http://204.87.169.110/accounts/" + params[:account][:id_cuenta_banco])
		res = Net::HTTP.get_response(uri)

		if res.code == '200'
			data = JSON.parse(res.body)
			if data["rut"] == current_client.rut
				@account = Account.new(account_params)
				if @account.save
					render :json => current_client.accounts, status: :ok
				else
					render :json => {}, status: :internal_server_error
				end
			else
				render :json => {}, status: :precondition_failed
			end
		else
			render :json => {}, status: :not_found
		end
	end

	# Not necessary
	def update
    	render :json => {}, status: :method_not_allowed
	end

	# Destroys an account. This actions can't be performed if the bill has a payment associated.
	def destroy
		@account = Account.find_by_id(params[:id])
    	if @account.destroy
			render :json => current_client.accounts
		else
			render :json => {}, status: :internal_server_error
		end
	end
end
