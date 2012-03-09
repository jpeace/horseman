require 'horseman/dom/element'

module Horseman
	module Dom
		class Form < Element
	    attr_accessor :action, :encoding, :fields, :submit

      def respond_to?(method_sym, include_private = false)
        true
      end

      def method_missing(method, *arguments, &block)
        case method
        when :[]
          indexer = arguments[0]
          field = @fields.select {|name, field| name.to_s == indexer}.map {|k,v| v}.first
          return field unless field.nil?  
        end
        
        puts "Not implemented in Form: #{method} #{arguments.join(',')}"
      end
	  end
	 
	  class FormField < Element
	    attr_accessor :type, :value

      def focus(argument=nil)
      end

      def respond_to?(method_sym, include_private = false)
        true
      end

      def method_missing(method, *arguments, &block)
        puts "Not implemented in FormField: #{method} #{arguments.join(',')}"
      end
	  end
	end
end