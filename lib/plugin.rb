module Assemble
	module Plugin
		module ClassMethods
			def registered_plugins
				@registered_plugins ||= {}
			end
			
			def registered_messages
				@registered_messages ||= []
			end
			
			def registered_commands
				@registered_commands ||= []
			end
			
			def repository
				@repository ||= []
			end
			
			def inherited(klass)
				registered_plugins[klass.to_s] = klass
				repository << klass
			end
			
			def on_message(regexp, *methods)
				methods.each do |method|
					registered_messages << Event::Message.new(regexp, self.to_s, method)
				end
			end
			
			def on_command(command, *methods)
				methods.each do |method|
					registered_commands << Event::Command.new(command, self.to_s, method)
				end
			end
		end
		
		def self.included(klass)
			klass.extend ClassMethods
		end

		# @registered_plugins = {}
		
		# @registered_commands = []
		# @registered_messages = []
		# @registered_speakers = []
		
		# def inherited(child)
			# puts "inherited ..."
			# Plugin.registered_plugins[child.to_s] = child.new
		# end
		
		# class << self
			# attr_reader :registered_plugins, :registered_commands, :registered_messages, :registered_speakers
			
			# def on_command(command, *methods)
				# methods.each do |method|
					# Plugin.registered_commands << Event::Command.new(command, self.to_s, method)
				# end
			# end
			
			# def on_message(regexp, *methods)
				# methods.each do |method|
					# Plugin.registered_messages << Event::Message.new(regexp, self.to_s, method)
				# end
			# end
		# end
	end

	class MessagePlugin
		include Plugin
	end
end