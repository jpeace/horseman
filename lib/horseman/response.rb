require 'nokogiri'

module Horseman
  class Element
    attr_accessor :id, :name
    def initialize(id='', name='')
      @id = id
      @name = name
    end
  end
  class Form < Element
    attr_accessor :action, :encoding, :fields, :submit
  end
  class FormField < Element
    attr_accessor :type, :value
  end
  
  class Response
    attr_reader :body, :forms
    
    def initialize(body)
      @body = body
      @forms = []
      
      @field_types = {
        'text' => :text,
        'checkbox' => :checkbox,
        'hidden' => :hidden,
        'submit' => :submit
      }
      
      @encoding_types = {
        'application/x-www-form-urlencoded' => :url,
        'multipart/form-data' => :multipart
      }
      parse
    end
    
    private
    
    def parse
      doc = Nokogiri::HTML(@body)
      doc.css('form').each do |f|
        form = Form.new(f.attr('id'), f.attr('name'))
        form.action = f.attr('action') || '/'
        form.encoding = @encoding_types[f.attr('enctype')] || :url
        form.fields = []
        f.css('input').each do |i|
          field = FormField.new(i.attr('id'), i.attr('name'))
          field.type = @field_types[i.attr('type')] || :text
          field.value = i.attr('value')

          form.fields << field 
          form.submit = field if (field.type == :submit)  
        end
        @forms << form
      end
    end       
  end
end