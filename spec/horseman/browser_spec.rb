require 'horseman/browser'

describe Horseman::Browser::Browser do
  include Mocks
  
  subject {described_class.new(connection, js_engine, 'http://www.example.com')}
  
  it "saves cookies" do
    subject.cookies.should be_empty

    subject.get!
    subject.cookies.count.should eq 2
    subject.cookies['name1'].should eq 'value1'
    subject.cookies['name2'].should eq 'value2'

    subject.connection.should_receive(:exec_request) do |request|
      request['cookie'].should match /\w+=\w+; \w+=\w+/
      request['cookie'].should match /name1=value1/
      request['cookie'].should match /name2=value2/
    end
    subject.get!
  end
  
  it "empties the cookies when the session is cleared" do
    subject.get!
    subject.cookies.should_not be_empty
    subject.clear_session
    subject.cookies.should be_empty
  end
  
  it "stores information about the last response" do
    subject.get!
    subject.last_action.response.body.should eq html
  end

  it "executes javascript" do
    subject.js_engine.should_receive(:execute) do |body, scope|
      ['alert("downloaded");', 'alert("hello");', 'alert("no type");'].should include(body)
    end.exactly(3).times

    subject.get!
  end

  context "when processing redirects" do
    
    def build_browser(options)
      code = options[:code] || '200'
      num_redirects = options[:redirects] || 1
      location = options[:location]
      r = response(:location => location)
      redirects = 0
      r.stub(:code) do
        code = (redirects >= num_redirects) ? '200' : code
        redirects += 1
        code
      end
      
      c = connection
      c.stub(:exec_request) { r }

      described_class.new(c, js_engine, 'http://www.example.com')    
    end
    
    def should_redirect(options)
      browser = build_browser(options)

      expected_url = options[:expected_url] || 'http://www.anotherdomain.com/path'  
      redirects = 0
      browser.connection.should_receive(:build_request).twice do |options|
        browser.connection.url = options[:url]
        if redirects > 0
          options[:url].should eq expected_url
        end
        redirects += 1
        request
      end
      browser.get!
    end
    
    it "follows 301s" do
      should_redirect(:code => '301')
    end
    
    it "follows 302s" do
      should_redirect(:code => '302')
    end
    
    it "follows 303s" do
      should_redirect(:code => '303')
    end
    
    it "follows 307s" do
      should_redirect(:code => '307')
    end
    
    it "follows relative paths" do
      should_redirect(:code => '301', :location => 'redirect', :expected_url => 'http://www.example.com/redirect')
    end
    
    it "raises an error after 10 consecutive redirects" do
      good_browser = build_browser(:code => '301', :redirects => 10)
      good_browser.get!
      
      bad_browser = build_browser(:code => '301', :redirects => 11)
      expect { bad_browser.get! }.to raise_error
    end
  end
    
  context "when posting" do
    def describe_url
      count = 0
      subject.connection.should_receive(:build_request).twice do |options|
        subject.connection.url = options[:url]
        yield options[:url] if (count > 0)
        count += 1
        request
      end
      post
    end
    
    def describe_request
      subject.connection.should_receive(:exec_request).twice do |request|
        if (request.method == "POST")
          yield request
        end
      end
      post
    end
    
    it "raises an error on invalid form id" do
      expect { subject.post!('/', :form => :bad_form) }.to raise_error
    end
    
    context "with a relative action" do
      def post
        subject.post!('/path', :form => :form1)
      end
      
      it "constructs the correct URL" do
        describe_url do |url|
          url.should eq 'http://www.example.com/action'
        end
      end
    end
    
    context "with an absolute action" do
      def post
        subject.post!('/path', :form => :form2)
      end
      
      it "constructs the correct URL" do
        describe_url do |url|
          url.should eq 'http://www.anotherdomain.com/action'
        end
      end
    end
    
    context "with no action" do
      def post
        subject.post!('/path', :form => :form3)
      end
      
      it "constructs the correct URL" do
        describe_url do |url|
          url.should eq 'http://www.example.com/path'
        end
      end
    end
    
    context "with unchecked checkboxes" do
      def post
        subject.post!('/path', :form => :form1, :data => {:text => "text_value"}, :unchecked => [:check])
      end
      
      it "does not include unchecked checkboxes" do
        describe_request do |request|
          request.body.should_not match /name="check"/
        end
      end
    end
  
    context "multipart data" do
      def post
        subject.post!('/', :form => :form1, :data => {:text => "text_value", :check => "checkbox_value"})
      end
      
      it "properly sets content type" do
        describe_request do |request|
          request['Content-Type'].should eq "multipart/form-data; boundary=#{subject.multipart_boundary}"
        end
      end
      
      it "properly encodes form data" do
        describe_request do |request|
          request.body.should match /\A--#{subject.multipart_boundary}.*--#{subject.multipart_boundary}--\Z/m
          request.body.should match /^--#{subject.multipart_boundary}\r\nContent-Disposition: form-data; name="text"\r\n\r\ntext_value/m
          request.body.should match /^--#{subject.multipart_boundary}\r\nContent-Disposition: form-data; name="check"\r\n\r\ncheckbox_value/m
        end
      end
    end

    context "URL encoded data" do
      def post
        subject.post!('/', :form => :form2, :data => {:text1 => "value1", :text2 => "value2"})
      end
    
      it "properly sets content type" do
        describe_request do |request|
          request['Content-Type'].should eq 'application/x-www-form-urlencoded'
        end
      end
      
      it "properly encodes form data" do
        describe_request do |request|
          request.body.should match /\w+=\w+&\w+=\w+/
          request.body.should match /text1=value1/
          request.body.should match /text2=value2/
        end
      end
    end
  end
end