require 'v8'

module Horseman
	class JavascriptEngine
		def execute(script, window)
			V8::Context.new(:with => window) do |ctx|
        ctx['location'] = window.location

        puts "Executing #{script}"
				ctx.eval(script)
      end
		end
	end  
end