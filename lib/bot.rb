require 'rubygems'
require 'yaml'
require 'logging'
require 'certified'
require 'tinder'

require 'active_support'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext'

require_relative 'message'
require_relative 'plugin'
require_relative 'event'

require 'pp'

module Assemble
	class Bot
		def initialize(config_file, plugin_path)
			Settings.load!(config_file)
			@plugin_path = plugin_path
			
			@rooms = {}
		end
		
		def connect
			load_plugins if Settings.config['enable_plugins']
			join_rooms
		end
		
		 def run(interval = 8)
			catch(:stop_listening) do
				trap('INT') { throw :stop_listening }
				
				@rooms.each_pair do |room_name, room|
					Thread.new do
						begin
							room.listen(:timeout => 10) do |raw_message|
								puts "raw_message: #{raw_message}"
								handle_message(Assemble::Message.new(raw_message.merge( { :room => room } )))
							end
						rescue Exception => e
							trace = e.backtrace.join('\r\n\t')
							puts "Something went wrong! #{e.message}\r\n #{trace}"
							# abort "something went wrong! #{e.message}\r\n #{trace}"
						end
					end
				end
			end
			
			loop do
				@rooms.each_pair do |room_name, room|
				end
				
				sleep interval
			end
		 end
		
		private
		
		def load_plugins
			dir = './plugins'
			
			$LOAD_PATH.unshift(dir)
			# TODO : Only load plugins specified in the config at some point?
			Dir[File.join(dir, '*.rb')].each { |file| require File.basename(file) }
		end
		
		def join_rooms
			@campfire = Tinder::Campfire.new(Settings.config['domain'], :token => Settings.config['api_key'])
			
			Settings.config['rooms'].each do |room_name|
				@rooms[room_name] = @campfire.find_room_by_name(room_name)
				
				puts "Joining room: #{room_name}"
				res = @rooms[room_name].join
			end
		end
	
		def handle_message(message)
			case message[:type]
				when "KickMessage"
					return
				when "TimestampMessage", "AdvertisementMessage"
					return
				when "TextMessage", "PasteMessage"
					unless message[:user][:id] == @campfire.me[:id]
						[:commands, :messages].each do |action|					
							MessagePlugin.repository.each do |plugin|
								plugin.send("registered_#{action.to_s}").each do |handler|
									begin
										handler.run(message) # if handler.can_handle?(action)
									rescue Exception => e
										puts "Error running #{handler.inspect}!: \r\n#{$!.class}: #{$!.message} \n #{$!.backtrace.join('\r\n\t')}"
									end
								end
							end
						end
					end
			end
		end
	end
	
	class Settings	
		def self.load!(config_file)
			@config = YAML::load(File.open(config_file))
		end
		
		def self.config
			@config
		end
	end
end