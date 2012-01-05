module Horseman
  class Cookie
    attr_reader :value, :domain, :path, :expiration
    
    def initialize(value, attributes)
      @value = value
      attributes.each {|a| parse_attribute(a)}
    end
    
    private
    
    def parse_attribute(attribute)
      md = /(\w+)=(.*)/.match(attribute)
      if md
        case md.captures[0].downcase
        when 'domain'
          @domain = md.captures[1]
        when 'path'
          @path = md.captures[1]
        when 'expires'
          @expiration = DateTime.parse(md.captures[1])
        when 'max-age'
          @expiration = DateTime.now + (md.captures[1] / (60 * 60 * 24))
        end
      end
    end    
  end
  
  class Cookies
    def initialize
      @dict = {}
    end
    
    def [](cookie_name)
      return @dict[cookie_name].value unless @dict[cookie_name].nil?
    end
    
    def get(cookie_name)
      return @dict[cookie_name]
    end
    
    def count
      @dict.count
    end
    
    def empty?
      @dict.count == 0
    end
    
    def to_s
      @dict.map {|k,v| "#{k}=#{v.value}"}.join('; ')
    end
    
    def update(header)
      if header.is_a?(Array)
        header.each {|h| parse_header(h)}
      else
        parse_header(header) unless header.nil?
      end
      self
    end
    
    private

    def parse_header(header)
      nvp, *attributes = *(header.split(';'))
      raise ArgumentError if nvp.nil?
      md = /(\w+)=(.*)/.match(nvp)
      raise ArgumentError if md.nil?
      name = md.captures[0]
      value = md.captures[1]

      @dict.merge!({name => Horseman::Cookie.new(value, attributes)})
    end
  end
end