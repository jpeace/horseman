require 'v8'

module Horseman
	class JavascriptEngine
		def test
		end

		def execute(script, global_scope=nil)
			V8::Context.new(:with => global_scope) do |ctx|
				ctx.eval(script)
      end
		end
	end
end