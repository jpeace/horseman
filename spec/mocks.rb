require 'horseman/connection'

module Mocks
  
  def html
    %{
      <html>
        <head></head>
        <body>
          <form id="form1" enctype="multipart/form-data" action="/action">
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
        </body>
      </html>
    }
  end
  
  def cookies
    ['name1=value1; Domain=www.example.com; Path=/path; Expires=Sun, 1-Jan-2012 00:00:00 GMT',
     'name2=value2; Domain=www.example.com; Path=/path; Expires=Sun, 1-Jan-2012 00:00:00 GMT']
  end
  
  def request
    m = double("HttpRequest")
    m.stub(:[]=) {}
    m
  end
  
  def response
    m = double("HttpResponse")
    m.stub(:[]) do |key|
      case key
      when 'set-cookie'
        cookies.join(', ')
      end
    end
    m.stub(:get_fields) do |key|
      case key
      when 'set-cookie'
        cookies
      end
    end
    m.stub(:body) { html }
    m
  end
  
  def connection
    c = Horseman::Connection.new
    c.stub(:exec_request) { response }
    c
  end
end