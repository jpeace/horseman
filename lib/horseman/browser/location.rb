require 'horseman/browser/whiny'

module Horseman
	module Browser
		class Location
			#include Whiny

			def initialize(window)
				@window = window
			end
			
			def href=(value)
				@window.browser.get! value, :no_base_url=>true
				# TODO - Can we stop executing javascript here?
			end
		end
	end
end