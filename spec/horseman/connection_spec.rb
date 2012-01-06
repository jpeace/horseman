require 'horseman/connection'
require 'net/http'

describe Horseman::Connection do
  subject do
    c = described_class.new
    c.url = 'http://www.example.com/some/path'
    c
  end
  
  context "when building requests" do  
    let(:request) {subject.build_request(:verb => :get)}
    
    it "uses the proper path" do
      request.path.should eq '/some/path'
    end
    
    context "using GET" do
      it "uses the proper request type" do
        request.class.should be Net::HTTP::Get
      end
    end
    
    context "using POST" do
      let(:request) {subject.build_request(:verb => :post)}
      
      it "uses the proper request type" do
        request.class.should be Net::HTTP::Post
      end

      context "with form data" do
        let(:request) {subject.build_request(:verb => :post, :form => {:field1=>'value1', :field2=>'value2'})}
        
        it "properly sets request body" do
          request.body.should eq 'field1=value1&field2=value2'
        end
      end

      context "without form data" do    
        it "properly sets request body" do
          request.body.should be_nil
        end
      end
    end    
  end
  
  context "when accessed using http" do
    it "does not use SSL" do
      subject.http.use_ssl?.should be_false
    end
  end
  
  context "when accessed using https" do
    subject do
      c = described_class.new
      c.url = 'https://www.example.com'
      c
    end

    it "uses SSL" do
      subject.http.use_ssl?.should be_true
    end
  end  
end