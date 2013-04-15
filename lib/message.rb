module Assemble
	class Message < ActiveSupport::HashWithIndifferentAccess
		def initialize(attributes)
			self.merge!(attributes)
			self[:message] = self['body']
			self[:person] = self['user']['name'] unless self['user'].nil?
			self[:room] = attributes[:room]
		end
		
		def reply(string)
			speak(string)
		end
		
		def speak(string)
			self[:room].speak(string)
		end
		
		def paste(string)
			self[:room].paste(string)
		end
		
		def play(string)
			self[:room].play(string)
		end
	end
end