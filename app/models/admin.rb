# = admin.rb
#
# Admin class, inherits from User (Single Table Inheritance). Abstracts the admin user.
class Admin < User

	# Admin can see all bills.
	def bills
		Cuenta.all 
	end

	def companies
		Empresa.all
	end

	# Includes type field in JSON response.
	def serializable_hash options=nil
  		super.merge "type" => type
	end
end
