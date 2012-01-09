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
  
  context "when posting" do
    def with_request
      subject.connection.should_receive(:exec_request).twice do |request|
        if (request.method == "POST")
          yield request
        end
      end
      post
    end
    
    it "raises an exception on invalid form id" do
      expect { subject.post!('/', :bad_form) }.to raise_error
    end
    
    context "multipart data" do
      def post
        subject.post!('/action', :form1, {:text => "text_value", :check => "checkbox_value"})
      end
      
      it "properly sets content type" do
        with_request do |request|
          request['Content-Type'].should eq "multipart/form-data; boundary=#{subject.multipart_boundary}"
        end
      end
      
      it "properly encodes form data" do
        with_request do |request|
          request.body.should match /^#{subject.multipart_boundary}.*#{subject.multipart_boundary}$/m
          request.body.should match /#{subject.multipart_boundary}.*Content-Disposition: form-data; name="text".*text_value/m
          request.body.should match /#{subject.multipart_boundary}.*Content-Disposition: form-data; name="check".*checkbox_value/m
        end
      end
    end

    context "URL encoded data" do
      def post
        subject.post!('/action', :form2, {:text1 => "value1", :text2 => "value2"})
      end
    
      it "properly sets content type" do
        with_request do |request|
          request['Content-Type'].should eq 'application/x-www-form-urlencoded'
        end
      end
      
      it "properly encodes form data" do
        with_request do |request|
          request.body.should match /\w+=\w+&\w+=\w+/
          request.body.should match /text1=value1/
          request.body.should match /text2=value2/
        end
      end
    end
  end
end