# = client.rb
#
# Client class, inherits from User (Single Table Inheritance). Abstracts the main client user. 
class Client < User
	# Many to one relationship with Bill (Cuenta)
	has_many :cuentas, primary_key: "rut", foreign_key: "rut_cliente"
	has_many :accounts, foreign_key: "rut"
	has_many :pagos, foreign_key: "rut_cliente"

	# Model validations. Self-explained.
	validates :rut, presence: true, uniqueness: true
end
