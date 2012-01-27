require 'horseman/dom/element'

module Horseman
	module Dom
		class Form < Element
	    attr_accessor :action, :encoding, :fields, :submit
	  end
	 
	  class FormField < Element
	    attr_accessor :type, :value
	  end
	end
end