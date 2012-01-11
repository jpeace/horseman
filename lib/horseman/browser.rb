require 'horseman/action'
require 'horseman/connection'
require 'horseman/cookies'
require 'securerandom'

module Horseman
  class Browser    
    MaxRedirects = 10
    
    attr_accessor :base_url
    attr_reader :cookies, :connection, :last_action, :multipart_boundary
    
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
      selected_form = @last_action.response.forms.select {|f| f.id && f.id.to_sym == form}.first
      raise "Could not find form #{form}" if selected_form.nil?

      selected_form.fields.each do |f|
        data[f.name.to_sym] ||= f.value
      end
      request_body = build_request_body(data, selected_form.encoding)
      
      if is_absolute_url(selected_form.action)
        # Absolute action http://www.example.com/action
        url = selected_form.action
      elsif selected_form.action == ''
        # No action, post to same URL as GET request
        url = "#{@last_action.url}"
      else
        # Relative action, use relative root from last action
        url = "#{@last_action.relative_root}#{selected_form.action}"
      end
      
      request = @connection.build_request(:url => "#{url}", :verb => :post, :body => request_body)
      request['Content-Type'] = case selected_form.encoding
                                when :multipart
                                  "multipart/form-data; boundary=#{@multipart_boundary}"
                                else
                                  "application/x-www-form-urlencoded"
                                end
      request['Referer'] = @last_action.url
      
      exec request
    end
    
    private
    
    def exec(request, redirects=0)
      request['Cookie'] = @cookies.to_s
      request['Content-Length'] = request.body ? request.body.length : 0
      request['User-Agent'] = 'Horseman'

      puts request.body
      request.each_header {|k,v| puts "#{k}: #{v}"}
      
      response = @connection.exec_request(request)
      
      @cookies.update(response.get_fields('set-cookie'))
      @last_action = Horseman::Action.new(@connection.uri, response)

      code = response.code
      puts code
      
      if ['301','302','303','307'].include? code
        raise "Redirect limit reached" if redirects >= MaxRedirects
        
        redirect_url = response['location']
        if !is_absolute_url(redirect_url)
          redirect_url = "#{@last_action.relative_root}#{redirect_url}"
        end
        puts redirect_url
        get!(redirect_url, :redirects => redirects+1, :no_base_url => true)
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
    
    def is_absolute_url(url)
      url[/\w+:\/\/.*/]
    end
  end
end