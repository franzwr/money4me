# = admin.rb
#
# Admin class, inherits from User (Single Table Inheritance). Abstracts the admin user.
class Admin < User
	def cuentas
		Cuenta.all 
	end
end
