module Horseman
	module Browser
		class Output
			def display(obj)
				puts obj
			end

      def error(message)
        puts message
      end
		end
	end
end
