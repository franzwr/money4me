class Empresa < RemoteBase
	self.table_name = "Empresa"
	self.primary_key = "id_empresa"
	has_many :empresarubros, foreign_key: "id_empresa"
	has_many :rubros, through: :empresarubros
	has_many :cuentas, foreign_key: "id_empresa"

  validates :rubros, presence: true, allow_blank: true

  validates :cuenta_banco_is_valid
  def cuenta_banco_is_valid
    response = `curl -w %{http_code} http://204.87.169.110/accounts/#{cuenta_banco.to_i}`

    errors.add(:cuenta_banco, "must be a valid bank account") unless response.end_with? "400"
  end
end
