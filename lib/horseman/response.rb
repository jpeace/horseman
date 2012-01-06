module Horseman
  class Element
    attr_accessor :id, :name
  end
  class Form < Element
  end
  class FormField < Element
    attr_accessor :type, :value
  end
  
  class Response
    attr_reader :body, :forms
    
    def initialize(body)
      @body = body
      @forms = []
      parse
    end
    
    private
    
    def parse
      
    end
  end
end