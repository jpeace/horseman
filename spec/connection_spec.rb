require 'horseman/connection'
require 'net/http'

describe Horseman::Connection do
  subject {described_class.new('http://www.example.com/some/path')}
  
  context "when building requests" do  
    let(:request) {subject.build_request(:get)}
    
    it "should use the proper path" do
      request.path.should eq '/some/path'
    end
    
    context "using GET" do
      it "should use the proper request type" do
        request.class.should be Net::HTTP::Get
      end
    end
    
    context "using POST" do
      let(:request) {subject.build_request(:post)}
      
      it "should use the proper request type" do
        request.class.should be Net::HTTP::Post
      end

      context "with form data" do
        let(:request) {subject.build_request(:post, {:field1=>'value1', :field2=>'value2'})}
        
        it "should properly set request body" do
          request.body.should eq 'field1=value1&field2=value2'
        end
      end

      context "without form data" do    
        it "should properly set request body" do
          request.body.should be_nil
        end
      end
    end    
  end
  
  context "when accessed using http" do
    it "should not use SSL" do
      subject.http.use_ssl?.should be_false
    end
  end
  
  context "when accessed using https" do
    subject {described_class.new('https://www.example.com')}

    it "should use SSL" do
      subject.http.use_ssl?.should be_true
    end
  end  
end