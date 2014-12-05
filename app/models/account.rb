# = account.rb
#
# Account class, inherits from ActiveRecord::Base. Abstraction of the bank accounts.
class Account < ActiveRecord::Base
	require 'net/http'
	# Many to one relationship with User.
	belongs_to :client, primary_key: "rut", foreign_key: "rut"

	# Model validations. Self-explained.
	validates :id_cuenta_banco, presence: true, uniqueness: true
	validates :rut, presence: true

	# Retrieves available funds from the bank API.
	def funds
		uri = URI.parse("http://204.87.169.110/accounts/" + id_cuenta_banco.to_s)
		res = Net::HTTP.get_response(uri)

		if res.code == '200'
			return JSON.parse(res.body)["fondo"]
		else
			return nil
		end
	end

end
