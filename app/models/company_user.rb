# = company_user.rb
#
# CompanyUser class. Inherits from User (Single Table Inheritance), and represents the user provided to Companies after form validation.
class CompanyUser < User
	# One to One relationship with Company (Empresa).
	belongs_to :empresa, foreign_key: "id_empresa"
	# One to Many relationship with Bills (Cuentas).
	has_many :cuentas, primary_key: "id_empresa", foreign_key: "id_empresa"

	# Model validations. Self-explained
	validates :id_empresa, presence: true, uniqueness: true

	def pagos
		Pago.select(:id_cuenta_banco => Empresa.find_by_id_empresa(:id_empresa).cuenta_banco)
	end
end