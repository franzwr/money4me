# = client.rb
#
# Client class, inherits from User (Single Table Inheritance). Abstracts the main client user. 
class Client < User
	# Many to one relationship with Bill (Cuenta)
	has_many :cuentas, primary_key: "rut", foreign_key: "rut_cliente"
	has_many :accounts, primary_key: "rut", foreign_key: "rut"
	has_many :pagos, primary_key: "rut", foreign_key: "rut_cliente"

	# Model validations. Self-explained.
	validates :rut, presence: true, uniqueness: true

	# Returns all the client's unpaid bills
	def unpaid_bills
		Cuenta.where.not(:id_cuenta => Detalle.where(:id_pago => Pago.select(:id_pago)).select(:id_cuenta)).where(:rut_cliente => rut)
	end

	# Includes type field in JSON response.
	def serializable_hash options=nil
  		super.merge "type" => type
	end
end
