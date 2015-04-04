require "horseman/browser/output"
require "horseman/browser/location"

module Horseman
	module Browser
		class Window
			attr_reader :browser, :output
			attr_reader :location, :document

			def initialize(browser, output=nil)
				output ||= Output.new

				@browser = browser
				@output = output
				
				@document = @browser.last_action.response.document
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

      def respond_to?(method_sym, include_private = false)
        true
      end

      def method_missing(method, *arguments, &block)
        puts "Not implemented in Window: #{method} #{arguments.join(',')}"
      end
		end
	end
end
