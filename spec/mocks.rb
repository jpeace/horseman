require 'horseman/connection'

module Mocks
  
  def html
    %{
      <html>
        <head></head>
        <body>
          <form id="form1">
            <input type="text" name="name1" value="value1" />
            <input type="submit" value="OK" />
          </form>
        </body>
      </html>
    }
  end
  
  def cookies
    ['name1=value1; Domain=www.example.com; Path=/path; Expires=Sun, 1-Jan-2012 00:00:00 GMT',
     'name2=value2; Domain=www.example.com; Path=/path; Expires=Sun, 1-Jan-2012 00:00:00 GMT']
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
    Horseman::Connection.any_instance.stub(:exec_request) { response }
    Horseman::Connection.new
  end
end