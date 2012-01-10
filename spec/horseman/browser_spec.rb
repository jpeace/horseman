require 'horseman/browser'

describe Horseman::Browser do
  include Mocks
  
  subject {described_class.new(connection, 'http://www.example.com')}
  
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
    subject.last_response.body.should eq html
  end

  context "when processing redirects" do
    
    def build_browser(code, num_redirects)
      r = response
      redirects = 0
      r.stub(:code) do
        code = (redirects >= num_redirects) ? '200' : code
        redirects += 1
        code
      end
      
      c = connection
      c.stub(:exec_request) { r }

      b = described_class.new(c, 'http://www.example.com')
      
      b
    end
    
    def should_redirect_for_code(code)
      browser = build_browser(code, 1)

      redirects = 0
      browser.connection.should_receive(:build_request).twice do |options|
        if redirects > 0
          options[:url].should eq 'http://www.anotherdomain.com/path'
        end
        redirects += 1
        request
      end
      browser.get!
    end
    
    it "follows 301s" do
      should_redirect_for_code('301')
    end
    
    it "follows 302s" do
      should_redirect_for_code('302')
    end
    
    it "follows 303s" do
      should_redirect_for_code('303')
    end
    
    it "follows 307s" do
      should_redirect_for_code('307')
    end
    
    it "raises an error after 10 consecutive redirects" do
      good_browser = build_browser('301', 10)
      good_browser.get!
      
      bad_browser = build_browser('301', 11)
      expect { bad_browser.get! }.to raise_error
    end
  end
    
  context "when posting" do
    def describe_url
      count = 0
      subject.connection.should_receive(:build_request).twice do |options|
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
      expect { subject.post!('/', :bad_form) }.to raise_error
    end
    
    context "with a relative action" do
      def post
        subject.post!('/path', :form1)
      end
      
      it "constructs the correct URL" do
        describe_url do |url|
          url.should eq 'http://www.example.com/action'
        end
      end
    end
    
    context "with an absolute action" do
      def post
        subject.post!('/path', :form2)
      end
      
      it "constructs the correct URL" do
        describe_url do |url|
          url.should eq 'http://www.anotherdomain.com/action'
        end
      end
    end
    
    context "with no action" do
      def post
        subject.post!('/path', :form3)
      end
      
      it "constructs the correct URL" do
        describe_url do |url|
          url.should eq 'http://www.example.com/path'
        end
      end
    end
    
    context "multipart data" do
      def post
        subject.post!('/', :form1, {:text => "text_value", :check => "checkbox_value"})
      end
      
      it "properly sets content type" do
        describe_request do |request|
          request['Content-Type'].should eq "multipart/form-data; boundary=#{subject.multipart_boundary}"
        end
      end
      
      it "properly encodes form data" do
        describe_request do |request|
          request.body.should match /^#{subject.multipart_boundary}.*#{subject.multipart_boundary}$/m
          request.body.should match /#{subject.multipart_boundary}.*Content-Disposition: form-data; name="text".*text_value/m
          request.body.should match /#{subject.multipart_boundary}.*Content-Disposition: form-data; name="check".*checkbox_value/m
        end
      end
    end

    context "URL encoded data" do
      def post
        subject.post!('/', :form2, {:text1 => "value1", :text2 => "value2"})
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