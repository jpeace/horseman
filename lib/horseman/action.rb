require 'horseman/response'

module Horseman
  class Action
    attr_reader :uri, :response
    
    def initialize(uri, response=nil)
      @uri = uri
      @response = Response.new(response.body, response.to_hash) unless response.nil?
    end
    
    def url
      "#{@uri.scheme}://#{@uri.host}#{@uri.path}" + (@uri.query ? "?#{@uri.query}" : "")
    end
    
    def relative_root
      "#{url.rpartition('/')[0]}/"
    end
  end
end