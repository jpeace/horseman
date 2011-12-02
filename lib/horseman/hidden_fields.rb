module Horseman
  class HiddenFields
    attr_reader :tokens

    def initialize(html)
      rx = /<input.* type=["']hidden["'].* name=["'](\S+)["'].* value=["'](\S*)["'].* \/>/
      @tokens = {}
      html.scan(rx).each {|field|
        @tokens[field[0]] = field[1]
      }
    end
  end
end