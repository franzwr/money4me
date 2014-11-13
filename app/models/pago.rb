# = pago.rb
#
# Payment (Pago) class, inherits from RemoteBase. Abstraction of the 'pagos' table from the external database.
# All relationships and validations are defined here. 
class Pago < RemoteBase

  # Table properties mapped to ActiveRecord
	self.table_name = "Pago"
	self.primary_key = "id_pago"

  # Many to many relationship with bills (cuentas).
	has_many :detalles, foreign_key: "id_pago"
	has_many :cuentas, through: :detalles

  # Many to One relationship with Client.
  belongs_to :client, primary_key: "rut_cliente", foreign_key: "rut"

  # Model validations. Self-explained.
  validates :cuentas, presence: true, allow_blank: false
  validates :id_cuenta_banco, presence: true
  validates :rut_cliente,  presence: true
  validates :email,        presence: true
end
