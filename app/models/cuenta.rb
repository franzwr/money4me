# = cuenta.rb
#
# Payment (Cuenta) class, inherits from RemoteBase. Abstraction of the 'Cuenta' table from the external database.
# All relationships and validations are defined here.
class Cuenta < RemoteBase
  # Table properties mapped to ActiveRecord
	self.table_name = "Cuenta"
	self.primary_key = "id_cuenta"

  # One to one relationship with Company (Empresa).
	belongs_to :empresa, foreign_key: "id_cuenta"
  # Many to One relationship with Payment (Pago).
	has_one :detalle, foreign_key: "id_cuenta"
	has_one :pago, through: :detalle
  # One to many relationship with User.
  belongs_to :client, foreign_key: "rut"

  # Model validations. Self-explained.
  validate :id_propio_empresa, presence: true, uniqueness: true
  validate :monto,             presence: true
  validate :rut_cliente,       presence: true

  # Bill can't expire before its created.
  validate :fecha_limite_after_fecha_registro
  def fecha_limite_after_fecha_registro
    errors.add(:fecha_limite, "must sucede fecha_registro") unless fecha_limite >= fecha_registro
  end
end
