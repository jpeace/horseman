require 'horseman/response'
require 'securerandom'

module Horseman
  class Browser
    attr_accessor :base_url
    attr_reader :cookies, :connection, :last_response, :multipart_boundary
    
    def initialize(connection, base_url='')
      @connection = connection
      @base_url = base_url
      @cookies = Horseman::Cookies.new
      @multipart_boundary = "----HorsemanBoundary#{SecureRandom.base64(8)}"
    end
    
    def clear_session
      @cookies.clear
    end
    
    def get!(path = '/')
      request = @connection.build_request(:url => "#{@base_url}#{path}", :verb => :get)
      exec request
    end
    
    def post!(path = '/', form = :form, data = {})
      get! path
      selected_form = @last_response.forms.select {|f| f.id.to_sym == form}.first
      raise "Could not find form #{:form}" if selected_form.nil?

      selected_form.fields.each do |f|
        data[f.name.to_sym] ||= f.value
      end
      request_body = build_request_body(data, selected_form.encoding)
      request = @connection.build_request(:url => "#{@base_url}#{path}", :verb => :post, :body => request_body)
      request['Content-Type'] = case selected_form.encoding
                                when :multipart
                                  "multipart/form-data; boundary=#{@multipart_boundary}"
                                else
                                  "application/x-www-form-urlencoded"
                                end
      exec request
    end
    
    private
    
    def exec(request)
      request['cookie'] = @cookies.to_s
      response = @connection.exec_request(request)
      @cookies.update(response.get_fields('set-cookie'))
      @last_response = Horseman::Response.new(response.body)
    end
    
    def build_request_body(data, encoding=:url)
      if encoding == :multipart
        data.map do |k,v|
          %{#{@multipart_boundary}
            Content-Disposition: form-data; name="#{k}"
            
            #{v}}
        end.join("\n") + @multipart_boundary
      else
        data.map {|k,v| "#{k}=#{v}"}.join('&')
      end
    end
  end
end