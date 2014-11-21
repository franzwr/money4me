# = account_controller.rb
#
# Controller class for all Account related actions.
class API::AccountController < ApplicationController

	# Only Clients can create and destroy accounts.
  	before_action :authenticate_client!, only: [:create, :destroy]

  	# Responds to and with JSON.
	respond_to :json

	# Permited params to bill creation.
	def account_params
		params.require(:cuenta).permit(:id_cuenta_banco, :rut)
	end

	# Not necessary
	def index
    	render :json => {}, status: :internal_server_error
	end

	# Not necessary
	def show
    	render :json => {}, status: :internal_server_error
	end

	# Creates a bill.
	def create
		@account = Account.new(account_params)
		if @account.save
			render :json => @account
		else
			render :json => {}, status: :internal_server_error
		end
	end

	# Not necessary
	def update
    	render :json => {}, status: :internal_server_error
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
