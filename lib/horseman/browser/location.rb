module Horseman
	module Browser
		class Location
			def initialize(window)
				@window = window
			end
			
			def href=(value)
				puts 'yo'
			end
		end
	end
end