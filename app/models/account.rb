# = account.rb
#
# Account class, inherits from ActiveRecord::Base. Abstraction of the bank accounts.
class Account < ActiveRecord::Base

	# Many to one relationship with User.
	belongs_to :client, primary_key: "rut", foreign_key: "rut"

	# Model validations. Self-explained.
	validates :id_cuenta_banco, presence: true, uniqueness: true
	validates :rut, presence: true

end
