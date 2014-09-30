class RemoteBase < ActiveRecord::Base
	self.abstract_class = true
	establish_connection :remote_development
end