require "open-uri"

class ExampleIO
  def read
    %{alert("downloaded");}
  end
end

class FrameIO
  def read
    %{
      <html>
        <body>
          <form id="form1" enctype="multipart/form-data" action="action">
            <input type="text" name="text" value="value1" />
            <input type="checkbox" name="check" value="value2" />
            <input type="hidden" name="hidden" value="value3" />
            <input type="submit" name="submit1" value="OK" />
          </form>
        </body>
      </html>
    }
  end
end

module OpenURI
  module OpenRead
    def open(*rest, &block)
      case host
      when "www.example.com"
        yield ExampleIO.new if block_given?
      when "www.some-frame.com"
        yield FrameIO.new if block_given?
      end
    end
  end
end
