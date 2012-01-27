require 'horseman/dom/document'

module Horseman
  class Response
    attr_reader :body, :headers, :document
    
    def initialize(body, headers={})
      @body = body
      @headers = headers
      @document = Dom::Document.new(@body)
    end
    
    def[](key)
      @headers[key]
    end
  end
end