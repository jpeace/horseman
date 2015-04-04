require "horseman/browser"

describe Horseman::Browser::Browser do
  include Doubles
  
  subject { described_class.new(connection, js_engine, "http://www.example.com")}
  
  it "saves cookies" do
    expect(subject.cookies).to be_empty

    subject.get!
    expect(subject.cookies.count).to eq 2
    expect(subject.cookies["name1"]).to eq "value1"
    expect(subject.cookies["name2"]).to eq "value2"

    expect(subject.connection).to receive(:exec_request) do |request|
      expect(request["cookie"]).to match /\w+=\w+; \w+=\w+/
      expect(request["cookie"]).to match /name1=value1/
      expect(request["cookie"]).to match /name2=value2/
      response
    end
    subject.get!
  end
  
  it "empties the cookies when the session is cleared" do
    subject.get!
    expect(subject.cookies).not_to be_empty
    subject.clear_session
    expect(subject.cookies).to be_empty
  end
  
  it "stores information about the last response" do
    subject.get!
    expect(subject.last_action.response.body).to eq html
  end

  context "when javascript is enabled" do
    subject {described_class.new(connection, js_engine, "http://www.example.com", :enable_js => true)}
    it "executes javascript" do
      expect(subject.js_engine).to receive(:execute) { |body, scope|
        expect([%{alert("downloaded");}, %{alert("hello");}, %{alert("no type");}]).to include(body)
      }.exactly(3).times

      subject.get!
    end
  end

  context "when processing redirects" do
    
    def build_browser(options)
      code = options[:code] || "200"
      num_redirects = options[:redirects] || 1
      location = options[:location]
      r = response(:location => location)
      redirects = 0
      allow(r).to receive(:code) do
        code = (redirects >= num_redirects) ? "200" : code
        redirects += 1
        code
      end
      
      c = connection
      allow(c).to receive(:exec_request) { r }

      described_class.new(c, js_engine, "http://www.example.com")    
    end
    
    def should_redirect(options)
      browser = build_browser(options)

      expected_url = options[:expected_url] || "http://www.anotherdomain.com/path"  
      redirects = 0
      expect(browser.connection).to receive(:build_request).twice do |options|
        browser.connection.url = options[:url]
        if redirects > 0
          expect(options[:url]).to eq expected_url
        end
        redirects += 1
        request
      end
      browser.get!
    end
    
    it "follows 301s" do
      should_redirect(:code => "301")
    end
    
    it "follows 302s" do
      should_redirect(:code => "302")
    end
    
    it "follows 303s" do
      should_redirect(:code => "303")
    end
    
    it "follows 307s" do
      should_redirect(:code => "307")
    end
    
    it "follows relative paths" do
      should_redirect(:code => "301", :location => "redirect", :expected_url => "http://www.example.com/redirect")
    end
    
    it "raises an error after 10 consecutive redirects" do
      good_browser = build_browser(:code => "301", :redirects => 10)
      good_browser.get!
      
      bad_browser = build_browser(:code => "301", :redirects => 11)
      expect { bad_browser.get! }.to raise_error
    end
  end
    
  context "when posting" do
    def describe_url
      count = 0
      expect(subject.connection).to receive(:build_request).twice do |options|
        subject.connection.url = options[:url]
        yield options[:url] if (count > 0)
        count += 1
        request
      end
      post
    end
    
    def describe_request
      expect(subject.connection).to receive(:exec_request).twice do |request|
        if (request.method == "POST")
          yield request
        end
        response
      end
      post
    end
    
    it "raises an error on invalid form id" do
      expect { subject.post!("/", :form => :bad_form) }.to raise_error
    end
    
    context "with a relative action" do
      def post
        subject.post!("/path", :form => :form1)
      end
      
      it "constructs the correct URL" do
        describe_url do |url|
          expect(url).to eq "http://www.example.com/action"
        end
      end
    end
    
    context "with an absolute action" do
      def post
        subject.post!("/path", :form => :form2)
      end
      
      it "constructs the correct URL" do
        describe_url do |url|
          expect(url).to eq "http://www.anotherdomain.com/action"
        end
      end
    end
    
    context "with no action" do
      def post
        subject.post!("/path", :form => :form3)
      end
      
      it "constructs the correct URL" do
        describe_url do |url|
          expect(url).to eq "http://www.example.com/path"
        end
      end
    end
    
    context "with unchecked checkboxes" do
      def post
        subject.post!("/path", :form => :form1, :data => {:text => "text_value"}, :unchecked => [:check])
      end
      
      it "does not include unchecked checkboxes" do
        describe_request do |request|
          expect(request.body).not_to match /name="check"/
        end
      end
    end
  
    context "multipart data" do
      def post
        subject.post!("/", :form => :form1, :data => {:text => "text_value", :check => "checkbox_value"})
      end
      
      it "properly sets content type" do
        describe_request do |request|
          expect(request["Content-Type"]).to eq "multipart/form-data; boundary=#{subject.multipart_boundary}"
        end
      end
      
      it "properly encodes form data" do
        describe_request do |request|
          expect(request.body).to match /\A--#{subject.multipart_boundary}.*--#{subject.multipart_boundary}--\Z/m
          expect(request.body).to match /^--#{subject.multipart_boundary}\r\nContent-Disposition: form-data; name="text"\r\n\r\ntext_value/m
          expect(request.body).to match /^--#{subject.multipart_boundary}\r\nContent-Disposition: form-data; name="check"\r\n\r\ncheckbox_value/m
        end
      end
    end

    context "URL encoded data" do
      def post
        subject.post!("/", :form => :form2, :data => {:text1 => "value1", :text2 => "value2"})
      end
    
      it "properly sets content type" do
        describe_request do |request|
          expect(request["Content-Type"]).to eq "application/x-www-form-urlencoded"
        end
      end
      
      it "properly encodes form data" do
        describe_request do |request|
          expect(request.body).to match /\w+=\w+&\w+=\w+/
          expect(request.body).to match /text1=value1/
          expect(request.body).to match /text2=value2/
        end
      end
    end
  end
end