# Payment Class.
class Pago < RemoteBase
	self.table_name = "Pago"
	self.primary_key = "id_pago"

  # Many to many relationship with bills.
	has_many :detalles, foreign_key: "id_pago"
	has_many :cuentas, through: :detalles

  # Model validations. Self-explained.
  validates :cuentas, presence: true, allow_blank: false

  validates :id_cuenta_banco, presence: true
  validates :rut_cliente,  presence: true
  validates :email,        presence: true
end
