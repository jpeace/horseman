require "horseman/connection"

module Mocks
  def html
    %{
      <html>
        <head>
          <script type="text/javascript" src="http://www.example.com/script.js"></script>
          <script type="text/javascript">
            alert("hello");
          </script>
          <script>
            alert("no type");
          </script>
          <script type="some/other/type">
            alert("invalid");
          </script>
        </head>
        <body>
          <form id="form1" enctype="multipart/form-data" action="action">
            <input type="text" name="text" value="value1" />
            <input type="checkbox" name="check" value="value2" />
            <input type="hidden" name="hidden" value="value3" />
            <input type="submit" name="submit1" value="OK" />
          </form>
          <form id="form2" action="http://www.anotherdomain.com/action">
            <input type="text" name="text1" />
            <input type="text" name="text2" />
            <input type="submit" name="submit2" value="OK" />
          </form>
          <form id="form3" action="">
          </form>
          <frame name="frame1" src="http://www.some-frame.com" />
        </body>
      </html>
    }
  end
  
  def cookies
    ["name1=value1; Domain=www.example.com; Path=/path; Expires=Sun, 1-Jan-2012 00:00:00 GMT",
     "name2=value2; Domain=www.example.com; Path=/path; Expires=Sun, 1-Jan-2012 00:00:00 GMT"]
  end
  
  def request
    r = double("HttpRequest")
    allow(r).to receive(:[]=) {}
    allow(r).to receive(:body) {}
    allow(r).to receive(:each_header) {}
    r
  end
  
  def response(options={})
    r = double("HttpResponse")
    allow(r).to receive(:code) { "200" }
    allow(r).to receive(:[]) do |key|
      case key
      when "set-cookie"
        cookies.join(", ")
      when "location"
        options[:location] || "http://www.anotherdomain.com/path"
      end
    end
    allow(r).to receive(:to_hash) { Hash.new }
    allow(r).to receive(:get_fields) do |key|
      case key
      when "set-cookie"
        cookies
      end
    end
    allow(r).to receive(:body) { html }
    r
  end
  
  def connection
    c = Horseman::Connection.new
    allow(c).to receive(:exec_request) { response }
    c
  end

  def js_engine
    e = double("JavascriptEngine")
    allow(e).to receive(:test) {}
    allow(e).to receive(:execute) {}
    e
  end
end