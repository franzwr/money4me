# = authorization_controller.rb
#
# Controller class for all devise related actions.
class AuthorizationController < ApplicationController
	respond_to :json

	# Permitted params for all user roles.
	def client_params
		params.require(:user).permit(:email, :rut, :name, :password, :password_confirmation, :uid)
	end
	def admin_params
		params.require(:user).permit(:email, :name, :password, :password_confirmation)
	end
	def company_user_params
		params.require(:user).permit(:email, :rut, :name, :password, :password_confirmation, :id_empresa)
	end

	# Signs In a user. Renders JSON containing the signed in resource.
	def login
		if @user = User.find_by_email(params[:user][:email])
			if @user.valid_password?(params[:user][:password])
				if @user.class.to_s == 'Client'
					sign_in(:client, @user)
					render :json => current_client, :include => [{:pagos => {:include => [{:cuentas => {:include => [:empresa]}}]}}, :accounts, {:unpaid_bills => {:include => [:empresa]}}], status: :ok
				elsif @user.class.to_s == 'Admin'
					sign_in(:admin, @user)
					render :json => current_admin, :include => [:cuentas] ,status: :ok
				else
					sign_in(:company_user, @user)
					render :json => current_company_user, :include => [:cuentas, :pagos] ,status: :ok
				end
			else
				render :json => {}, status: :unauthorized
			end
		else
			render :json => {}, status: :unauthorized
		end
	end

	# Signs out any kind of user.
	def logout
		sign_out :user
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
				# Company User registration. Does not follows up with a sign in.
				elsif params[:user][:type] == 'CompanyUser'
					@company_user = CompanyUser.new(company_user_params)
					if @company_user.save
						UserMailer.welcome_email(@company_user, company_user_params.password).deliver
						render :json => @company_user, status: :ok
					else
						render :json => {:errors => @company_user.errors}, status: :unprocessable_entity
					end
				end
			else
				render :json => {}, status: :unauthorized
			end
		end
	end

	def recover

	end
end