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
  
  it "stores information about the last response" do
    subject.get!
    subject.last_response.body.should eq html
  end
  
  it "empties the cookies when the session is cleared" do
    subject.get!
    subject.cookies.should_not be_empty
    subject.clear_session
    subject.cookies.should be_empty
  end
end