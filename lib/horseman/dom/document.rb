require 'open-uri'
require 'nokogiri'

require 'horseman/dom/form'
require 'horseman/dom/script'

module Horseman
	module Dom
		class Document

			attr_reader :forms, :scripts, :frames, :dom

			def initialize(body)
				@forms = {}
				@scripts = []
				@frames = {}

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

	      valid_script_types = ['javascript', 'text/javascript']
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

	      doc.css('frame').select{|f| f.attr('src') && f.attr('name')}.each do |f|
	      	frame_body = open(f.attr('src')) {|f| f.read.strip}
	      	@frames[f.attr('name').to_sym] = Document.new(frame_body)
	      end

	      @dom = doc
			end

			def respond_to?(method_sym, include_private = false)
        true
      end

      def method_missing(method, *arguments, &block)
      	case method
      	when :[]
      		indexer = arguments[0]
      		form = @forms.select {|id, form| id.to_s == indexer}.map {|k,v| v}.first
      		return form unless form.nil?
      	end

        puts "Not implemented in Document: #{method} #{arguments.join(',')}"
      end
		end
	end
end