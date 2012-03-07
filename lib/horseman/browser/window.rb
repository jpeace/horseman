require 'horseman/browser/output'
require 'horseman/browser/location'

module Horseman
	module Browser
		class Window
			attr_reader :browser
			attr_reader :location

			def initialize(browser, output=nil)
				output ||= Output.new

				@browser = browser
				@output = output
				
				@location = Location.new(self)
			end

			def alert(message)
				output.display message
			end

			def top
				self
			end
			def window
				self
			end
		end
	end
end