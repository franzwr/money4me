# Company Class
class Empresa < RemoteBase
	self.table_name = "Empresa"
	self.primary_key = "id_empresa"

  # Many to many relationship with entry.
	has_many :empresarubros, foreign_key: "id_empresa"
	has_many :rubros, through: :empresarubros

  # One to many relationship with bills.
	has_many :cuentas, foreign_key: "id_empresa"

  # One to one relationship with user.
  has_one :user, foreign_key: "id_empresa" 

  # Model validations. Self-explained.
  validates :rubros, presence: true, allow_blank: true

end
