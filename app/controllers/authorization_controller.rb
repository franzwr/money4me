# = authorization_controller.rb
#
# Controller class for all devise related actions.
class AuthorizationController < ApplicationController
	respond_to :json
	skip_before_filter :verify_authenticity_token, only: [:recover]

	require 'net/http'

	# Permitted params for all user roles.
	def client_params
		params.require(:user).permit(:email, :rut, :name, :password, :password_confirmation, :uid, :type)
	end
	def admin_params
		params.require(:user).permit(:email, :name, :password, :password_confirmation, :type)
	end
	def company_user_params
		params.require(:user).permit(:email, :rut, :name, :id_empresa, :type)
	end

	# Signs In a user. Renders JSON containing the signed in resource.
	def login
		if client_signed_in?
			render :json => current_client, :include => [{:pagos => {:include => [{:cuentas => {:include => [:empresa]}}]}}, :accounts, {:unpaid_bills => {:include => [:empresa]}}], status: :ok
		elsif admin_signed_in?
			render :json => current_admin, :include => [:users, {:companies => {:include => [:company_user]}}] ,status: :ok
		elsif company_user_signed_in?
			render :json => current_company_user, :include => [:cuentas, :pagos] ,status: :ok
		else
			if @user = User.find_by_email(params[:user][:email])
				if @user.valid_password?(params[:user][:password])
					if @user.class.to_s == 'Client'
						sign_in(:client, @user)
						render :json => current_client, :include => [{:pagos => {:include => [{:cuentas => {:include => [:empresa]}}]}}, :accounts, {:unpaid_bills => {:include => [:empresa]}}], status: :ok
					elsif @user.class.to_s == 'Admin'
						sign_in(:admin, @user)
						render :json => current_admin, :include => [:users, {:companies => {:include => [:company_user]}}] ,status: :ok
					else
						@empresa = Empresa.find_by(:id_empresa => @user.id_empresa)
						if @empresa && @empresa.activa
							sign_in(:company_user, @user)
							render :json => current_company_user, :include => [:cuentas, :pagos] ,status: :ok
						else
							render :json => {}, status: :unauthorized
						end
					end
				else
					render :json => {}, status: :unauthorized
				end
			else
				render :json => {}, status: :unauthorized
			end
		end
	end

	# Signs out any kind of user.
	def logout
		if client_signed_in?
			sign_out :client 
		elsif admin_signed_in?
			sign_out :admin
		elsif company_user_signed_in?
			sign_out :company_user
		end
		render :json => {}, status: :ok
	end

	# Registers a user. Only admins can create new admins or company users.
	def sign_up
		# Normal client registration. 
		if params[:user][:type] == 'Client'
			@client = Client.new(client_params)
			if @client.save
				sign_in(:client, @client)
				UserMailer.welcome_email(@client, nil).deliver
				render :json => @client, status: :ok
			else
				render :json => {:errors => @client.errors}, status: :unprocessable_entity
			end
		# Company User registration. Does not follows up with a sign in.
		elsif params[:user][:type] == 'CompanyUser'
			@company_user = CompanyUser.new(company_user_params)
			@company_user.password = Devise.friendly_token[0,10]
			@company_user.password_confirmation = @company_user.password
			if @company_user.save
				UserMailer.welcome_email(@company_user, @company_user.password).deliver
				render :json => @company_user, status: :ok
			else
				@company  = Empresa.find_by(:id_empresa => params[:user][:id_empresa])
				if @company && @company.cuentas.length == 0
					if @company.destroy
						render :json => {:errors => @company_user.errors}, status: :internal_server_error
					end
				else
					render :json => {:errors => @company_user.errors}, status: :unprocessable_entity
				end
			end
		else
			# Admin must be authenticated
			if admin_signed_in?
				# Admin registration. Does not follows up with a sign in.
				if params[:user][:type] == 'Admin'
					@admin = Admin.new(admin_params)
					if @admin.save
						render :json => @admin, status: :ok
						UserMailer.welcome_email(@admin, admin_params.password).deliver
					else
						render :json => {:errors => @admin.errors}, status: :unprocessable_entity
					end
				end
			else
				render :json => {}, status: :unauthorized
			end
		end
	end

	# Updates the client recovery status, so its visible for admins. Performs the recaptcha and other verifications.
	def recover
		# Recaptcha verification
		uri = URI.parse("https://www.google.com/recaptcha/api/siteverify?secret=6LeCzP4SAAAAACVmD51J75GBQRP_aGX0C8ESaAU1&response=" + params[:response])
		res = Net::HTTP.get_response(uri)
		data = JSON.parse(res.body)

		if res.code == '200' && data["success"]
			@user = Client.where(:rut => params[:rut], :email => params[:email]).first
			# Verifies that this client is not already asking for a password reset. 
			if @user && !@user.recovery
				@user.recovery = true
				@user.save
				render :json => {}, status: :ok
			else
				render :json => {success: true}, status: :unprocessable_entity
			end
		else
			render :json => {success: false}, status: :unprocessable_entity
		end
	end

end