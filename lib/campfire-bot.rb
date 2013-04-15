require 'rubygems'
require_relative 'bot'

bot = Assemble::Bot.new('config.yml', 'plugins')
bot.connect
bot.run