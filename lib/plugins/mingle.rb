require 'rubygems'
require 'httparty'
require 'crack'

require 'pp'

module Assemble
	class Mingle < Assemble::MessagePlugin
		on_command 'mingle', :mingle
		on_command 'owner', :owner
		
		on_message Regexp.new(".*(Card|Story|Task) #*(?<card>[0-9]+)", Regexp::IGNORECASE), :mingle_card
		
		
		def mingle(message)
			params = message[:message].split(' ')
			card_number = params.first.gsub '#', ''

			return unless card_number.numeric? and card_number.to_i > 0
			
			xml = get_mingle_data(card_number)
			return if xml.empty?
			response = get_response_from(xml, card_number)
			
			message.speak(response)
		end
		
		def owner(message)
			
		end
		
		def mingle_card(message)
			card_regexp = Regexp.new("#*(?<card>[0-9]+)", Regexp::IGNORECASE)
			match = message[:message].match(card_regexp)
			card_number = match[:card]

			xml = get_mingle_data(card_number)
			return if xml.empty?
			response = get_response_from(xml, card_number)
			
			message.speak(response)
		end
		
		private
		
		def get_mingle_data(card_number)
			url = "http://#{Settings.config["mingle_domain"]}/api/v2/projects/assemble/cards/#{card_number}.xml"

			auth = { username: Settings.config["mingle_username"], password: Settings.config["mingle_password"] }
			auth_options = { :basic_auth => auth }

			response = HTTParty.get(url, auth_options)
			
			xml = Crack::XML.parse(response.body)
			xml
		end
		
		def get_response_from(xml, card_number)
			created_by = xml["card"]["created_by"]["name"]
			modified_on = xml["card"]["modified_on"]

			owner_property = find_property(xml, "Owner")["value"]
			story_type_property = find_property(xml, "Story Type")
			status_property = find_property(xml, "Status")			
			owner_property = find_property(xml, "Owner")

			"Card ##{card_number} - #{xml["card"]["name"]} [Story Type: #{story_type_property["name"]}] [Owner: #{owner_property["name"]}] [Status: #{status_property["value"]}] [Created By: #{created_by}] [Last Updated: #{modified_on}] :: http://mingle.assemblesystems.com/projects/assemble/cards/#{card_number}"
		end
		
		def find_property(xml, property_name)
			xml["card"]["properties"].select { |property| property["name"] == property_name }.first
		end

	end
end

class String
	def numeric?
		Float(self) != nil rescue false
	end
end