require 'horseman/browser/output'
require 'horseman/browser/location'

module V8
  class Access
    def get(obj, name, &dontintercept)

    	puts "V8: #{obj.class.name} - #{name}"
      methods = accessible_methods(obj)
      if methods.include?(name)
        method = obj.method(name)
        method.arity == 0 ? method.call : method.unbind
      elsif obj.respond_to?(:[])
        obj.send(:[], name, &dontintercept)
      else
        yield
      end
    end
  end
end

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
		end
	end
end