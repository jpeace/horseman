require 'uri'
require 'net/http'
require 'net/https'

module Horseman
  class Connection
    attr_reader :http

    def url=(url)
      @uri = URI.parse(url)
      build_http
    end

    def exec_request(request)
      @http.request(request)
    end
       
    def build_request(options={})
      self.url = options[:url] unless options[:url].nil?
      options[:verb] == (:get || nil) ? build_get_request : build_post_request(options[:form])
    end
    
    private
    
    def build_http
      @http = Net::HTTP.new(@uri.host, @uri.port)
      if (@uri.port == 443)
        @http.use_ssl = true
      end
    end

    def build_get_request
      return Net::HTTP::Get.new(@uri.request_uri)
    end
    
    def build_post_request(form)
      ret = Net::HTTP::Post.new(@uri.request_uri)
      ret.form_data = form unless form.nil?
      return ret
    end
  end
end