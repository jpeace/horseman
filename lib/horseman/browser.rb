require 'horseman/response'

module Horseman
  class Browser
    attr_accessor :base_url
    attr_reader :cookies, :connection, :last_response
    
    def initialize(connection, base_url='')
      @connection = connection
      @base_url = base_url
      @cookies = Horseman::Cookies.new
    end
    
    def clear_session
      @cookies.clear
    end
    
    def get!(path = '/')
      request = @connection.build_request(:url => "#{@base_url}#{path}", :verb => :get)
      exec(request)
    end
    
    private
    
    def exec(request)
      request['cookie'] = @cookies.to_s
      response = @connection.exec_request(request)
      @cookies.update(response.get_fields('set-cookie'))
      @last_response = Horseman::Response.new(response.body)
    end
  end
end