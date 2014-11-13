# = remote_base.rb
#
# RemoteBase class, inherits from ActiveRecord::Base. This class is abstract, and its used as a base for all
# other classes from the external database.
class RemoteBase < ActiveRecord::Base

	# Abstract class
	self.abstract_class = true
	# Sets connections parameters to reach the external database. Parameters defined in /config/database.yml.
	establish_connection :remote_development
end