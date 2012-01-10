require 'horseman/connection'
require 'horseman/cookies'
require 'horseman/response'
require 'securerandom'

module Horseman
  class Browser
    attr_accessor :base_url
    attr_reader :cookies, :connection, :last_response, :multipart_boundary
    
    def self.with_base_url(base_url)
      Horseman::Browser.new(Horseman::Connection.new, base_url)
    end
    
    def initialize(connection, base_url='')
      @connection = connection
      @base_url = base_url
      @cookies = Horseman::Cookies.new
      @multipart_boundary = "----HorsemanBoundary#{SecureRandom.hex(8)}"
    end
    
    def clear_session
      @cookies.clear
    end
    
    def get!(path = '/', options = {})
      url = options[:no_base_url] ? path : "#{@base_url}#{path}"
      request = @connection.build_request(:url => url, :verb => :get)
      redirects = options[:redirects] || 0
      exec(request, redirects)
    end
    
    def post!(path = '/', form = :form, data = {})
      get! path
      selected_form = @last_response.forms.select {|f| f.id.to_sym == form}.first
      raise "Could not find form #{form}" if selected_form.nil?

      selected_form.fields.each do |f|
        data[f.name.to_sym] ||= f.value
      end
      request_body = build_request_body(data, selected_form.encoding)
      
      if selected_form.action[/\w+:\/\/.*/]
        # Absolute action http://www.example.com/action
        url = selected_form.action
      elsif selected_form.action == ''
        # No action, post to same URL as GET request
        url = "#{base_url}#{path}"
      else
        # Relative action, reuse scheme and host from GET request
        uri = URI.parse("#{base_url}#{path}")
        url = "#{uri.scheme}://#{uri.host}#{selected_form.action}"
      end
      
      request = @connection.build_request(:url => "#{url}", :verb => :post, :body => request_body)
      request['Content-Type'] = case selected_form.encoding
                                when :multipart
                                  "multipart/form-data; boundary=#{@multipart_boundary}"
                                else
                                  "application/x-www-form-urlencoded"
                                end
      exec request
    end
    
    private
    
    def exec(request, redirects=0)
      request['cookie'] = @cookies.to_s
      response = @connection.exec_request(request)
      
      pp response.code
      @cookies.update(response.get_fields('set-cookie'))
      @last_response = Horseman::Response.new(response.body)

      if response.code == '301'
        get!(response['location'], :redirects => redirects+1, :no_base_url => true)
      end
    end
    
    def build_request_body(data, encoding=:url)
      if encoding == :multipart
        data.map do |k,v|
          %{#{@multipart_boundary}
            Content-Disposition: form-data; name="#{k}"
            
            #{v}}
        end.join("\n") + "\n#{@multipart_boundary}"
      else
        data.map {|k,v| "#{k}=#{v}"}.join('&')
      end
    end
  end
end