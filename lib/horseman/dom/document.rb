require 'open-uri'
require 'nokogiri'

require 'horseman/dom/form'
require 'horseman/dom/script'

module Horseman
	module Dom
		class Document
			attr_reader :forms, :scripts

			def initialize(body)
				@forms = {}
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
	        form.fields = {}
	        
	        f.css('input').select{|i| i.attr('name')}.each do |i|
	          field = FormField.new(i.attr('id'), i.attr('name'))
	          field.type = @field_types[i.attr('type')] || :text
	          field.value = i.attr('value')

	          form.fields[field.name.to_sym] = field 
	          form.submit = field if (field.type == :submit)  
	        end
	        
	        @forms[form.id.to_sym] = form
	      end

	      valid_script_types = ['text/javascript']
	      doc.css('script').select{|s| (s.attr('type').nil?) || (valid_script_types.include? s.attr('type')) }.each do |s|
	      	script = Script.new
	      	if s.attr('src')
	      		# TODO -- account for HTTP failures
	      		script.body = open(s.attr('src'))	{|f| f.read.strip}
	      	else
	      		script.body = s.inner_html.strip
	      	end

	      	@scripts << script
	      end
			end
		end
	end
end