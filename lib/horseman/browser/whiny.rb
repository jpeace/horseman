require 'horseman/browser/output'

module Horseman
  module Browser
    module Whiny
      @output = Horseman::Browser::Output.new

      def method_missing(method, *arguments, &block)
        @output.error "Not implemented: #{method}"
      end
    end
  end
end