require 'nokogiri'
require 'horseman/dom/form'
require 'horseman/dom/script'

module Horseman
	module Dom
		class Document
			attr_reader :forms, :scripts

			def initialize(body)
				@forms = []
				@scripts = []

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
	      
				parse! body
			end

			private

			def parse!(body)
				doc = Nokogiri::HTML(body)
	      
	      doc.css('form').select{|f| f.attr('id')}.each do |f|
	        form = Form.new(f.attr('id'), f.attr('name'))
	        form.action = f.attr('action') || '/'
	        form.encoding = @encoding_types[f.attr('enctype')] || :url
	        form.fields = []
	        f.css('input').select{|i| i.attr('name')}.each do |i|
	          field = FormField.new(i.attr('id'), i.attr('name'))
	          field.type = @field_types[i.attr('type')] || :text
	          field.value = i.attr('value')

	          form.fields << field 
	          form.submit = field if (field.type == :submit)  
	        end
	        @forms << form
	      end

	      doc.css('script').select{|s| s.attr('type') == 'text/javascript'}.each do |script|
					# parse scripts      
	      end
			end
		end
	end
end