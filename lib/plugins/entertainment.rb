require 'rubygems'

module Assemble
	class Entertainment < Assemble::MessagePlugin
		on_command 'say', :say
		on_command 'blame', :blame
		on_command 'trout', :trout
		on_command 'slap', :slap
	
		on_message Regexp.new("^(Fuck you|damn you).*", Regexp::IGNORECASE), :not_nice_language
		on_message Regexp.new("^(Is it).*fault.*\?", Regexp::IGNORECASE), :whose_fault
		on_message Regexp.new("^(who|whose|who is) Squeaks?", Regexp::IGNORECASE), :say_hello
		on_message Regexp.new("^(Squeaks[,:]*\s)*(should|can|will) (i|you|he|she|we|they) (.+\?)", Regexp::IGNORECASE), :magic_eight_ball
		on_message Regexp.new("^(good mornin['g]*|mornin['g]*|hello|hi|hey|sup|what's up|yo)(,)\s*(Squeaks)[.!]*", Regexp::IGNORECASE), :greetings
		# on_message Regexp.new("^(how's|how|how are) (it |are |ya |you)*(ya|doing|going|doin)*['?]*", Regexp::IGNORECASE), :how_are_you

		def initialize
			puts "Loading Entertainment Plugin ..."
		end
		
		def say(message)
			message.speak(message[:message])
		end
		
		def not_nice_language(message)
			responses = [
				"Now that's not nice.", "You kiss your mother with that mouth?",
				"Ear muffs!", "Potty mouth.", "According to Adam there are customers who can see that ...",
				"Here's a quarter ..."]
			
			message.speak(responses.sample)
		end
		
		def blame(message)
			responses = [
				"Let's blame Trent!",
				"It was probably Trent.",
				"He who points the finger has three fingers pointing back at him.",
				"Pointing fingers at people and three back with one pointing ... or something like that.",
				"Gremlins. Gremlins most likely did it.",
				"I have no idea."]
			message.speak(responses.sample)
		end
		
		def whose_fault(message)
			responses = [
				"I doubt it. Is Trent around?",
				"Hmmm ...",
				"Probably not.",
				"I think so.",
				"I think it could be.",
				"Have you met Trent? I'd start there.",
				"More than likely it was Trent's fault.",
				"I'm not entirely sure this time ...",
				"Did you click ALL THE THINGS?!"]
				
			message.speak(responses.sample)
		end
		
		def say_hello(message)
			responses = [
			"Hello there. I'm your friendly bot Squeaks! When's happy hour?", 
			"Hi there, #{message[:person]}! Want to browse reddit with me?",
			"I'm a paranoid android.",
			"I'm just a figment of your imagination.",
			"I think a more appropriate question is: should we blame Trent?"]
			
			message.speak(responses.sample)
		end
		
		def greetings(message)
			messages = [
				"Hey there",
				"Howdy",
				"What's up",
				"Hello",
				"Hey there, buddy",
				"Let's get to Assemblin'",
				"G'day",
				"Cheers",
				"Sup",
				"Hey, it's a"]
			punctuation = ['.', '!']
			
			message.speak("#{messages.sample} #{message[:person]}#{punctuation.sample}")
		end
			
		def magic_eight_ball(message)
			responses = [
				"I'd like to think so.",
				"Have you asked Google?",
				"Check with Google, I'm out of answers.",
				"Definitely.",
				"Probably not.",
				"Go for it!",
				"Don't do it.",
				"Probably.",
				"Obviously.",
				"42.",
				"I'm just a robot. How could I possibly know that? But, Yes.",
				"You should probably ask someone else that question.",
				"Google knows way more about that than I do.",
				"I'm sorry. I was day-dreaming. What was the question?",
				"How much wood could a wood chuck chuck if a wood chuck could chuck wood?"]
			message.speak(responses.sample)
		end
		
		def how_are_you(message)
			responses = ["meh", "Just fine! You?", "Peachy keen. Yourself?", "Well, I started on reddit an hour ago and it's now #{Time.now.strftime('%I:M')}. How's that for productivity?", "I've been searching reddit all day ...", "Pretty good.", "Do I know you?"]
			message.speak(responses.sample)
		end
	end
end