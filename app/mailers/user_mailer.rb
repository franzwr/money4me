# = user_mailer.rb
#
# Defines all user related mailer actions. 
class UserMailer < ActionMailer::Base
	default from: 'no-reply@money4me.cl'

	# Welcome email send to users. Special layouts are defined for Admins and Companies.
	def welcome_email(user, password)
		@user = user
		@url = 'http://localhost:3000/'
		@password = password if password != nil

		if @user.is_a? Client 
			@layout = 'welcome_client'
		elsif @user.is_a? Admin
			@layout = 'welcome_admin'
		else
			@layout = 'welcome_company'
		end

		mail(to: @user.email, subject: 'Bienvenido a Money4Me', template_name: @layout) 
	end

  def payment_email(pago, email)
    @pago = pago
		mail(to: email, subject: 'Transferencia en Money4Me') 
  end

  def activation_email(user)
  	@user = user
  	@url = 'http://localhost:3000/'
  	mail(to: @user.email, subject: 'Cuenta Activada')
  end
end
