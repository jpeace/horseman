module Horseman
	module Browser
		class Location
			def initialize(window)
				@window = window
			end
			
			def href=(value)
				@window.browser.get! value, :no_base_url=>true
				# TODO - Can we stop executing javascript here?
			end

      def respond_to?(method_sym, include_private = false)
        true
      end

      def method_missing(method, *arguments, &block)
        puts "Not implemented in Location: #{method} #{arguments.join(',')}"
      end
		end
	end
end