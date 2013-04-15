module Assemble
	module Event
		class EventHandler
			attr_reader :kind, :matcher, :plugin, :method
			
			def self.handles(event_type)
				@kind = event_type
			end
			
			def initialize(matcher, plugin_name, method_name)
				@matcher = matcher
				@plugin = plugin_name
				@method = method_name
			end
			
			def run(message, force = false)
				if (force || match?(message))
					instance = MessagePlugin.registered_plugins[@plugin].new
					instance.send(@method, filter_message(message))
					# plugin_class = Plugin.registered_plugins[@plugin].new
					# puts "#{plugin_class} calling '#{@method}'"
					# plugin_class.send(@method, filter_message(message))
				else
					false
				end
			end
			
			def filter_message(message)
				message
			end
			
			def can_handle?(action)
				puts "kind: #{@kind}"
				puts "action: #{action}"
				@kind == action
			end
		end
		
		class Command < EventHandler
			handles :commands
			
			def match?(message)
				message[:message] =~ Regexp.new("^(!|Squeaks[,:]\s+)#{@matcher.downcase}\s*", Regexp::IGNORECASE)
			end
			
			
			def filter_message(message)
				message[:message] = message[:message].gsub(Regexp.new("^(!|Squeaks[,:]\s+)#{@matcher.downcase}\s*", Regexp::IGNORECASE), '')
				message
			end
		end
		
		class Message < EventHandler
			handles :messages
			
			def match?(message)
				message[:message] =~ @matcher
			end
		end
	end
end