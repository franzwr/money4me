# = admin.rb
#
# Admin class, inherits from User (Single Table Inheritance). Abstracts the admin user.
class Admin < User

	# Admin sees users asking for password recovery.
	def users
		User.where.not(:reset_password_token => nil)
	end
	
	# Admin sees all companies.
	def companies
		Empresa.all
	end

	# Includes type field in JSON response.
	def serializable_hash options=nil
  		super.merge "type" => type
	end
end
