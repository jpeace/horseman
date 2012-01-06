require 'horseman/cookies'

class Yo
  def test
    pp "yo"
  end
end

describe Horseman::Cookies do
  let(:simple_header) {'name1=value1'}
  let(:complex_header) {'name2=value2; Domain=www.example.com; Path=/path; Expires=Sun, 1-Jan-2012 00:00:00 GMT'}
  
  it "starts empty" do
    subject.should be_empty
  end
  
  it "accepts a single header" do
    subject.update(simple_header)['name1'].should eq 'value1' 
  end
  
  it "accepts multiple headers" do
    subject.update([simple_header, complex_header])
    subject['name1'].should eq 'value1'
    subject['name2'].should eq 'value2'
  end
  
  it "captures attributes" do
    subject.update(complex_header)
    subject.get('name2').domain.should eq 'www.example.com'
    subject.get('name2').path.should eq '/path'
    subject.get('name2').expiration.should eq DateTime.new(2012, 1, 1, 0, 0, 0, 0)
  end
  
  it "accepts an empty array" do
    subject.update([]).should be_empty
  end
  
  it "accepts nil" do
    subject.update(nil).should be_empty
  end
  
  it "raises an exception on an unrecognized header" do
    expect {subject.update('bad header')}.to raise_error(ArgumentError)
  end
  
  it "generates a correct header" do
    header = subject.update([simple_header, complex_header]).to_s
    header.should match /\w+=\w+; \w+=\w+/
    header.should match /name1=value1/
    header.should match /name2=value2/
  end
  
  context "with prexisting values" do
    subject do
      described_class.new.update('name1=other_value')
    end
    
    it "returns nil for uninitialized values" do
      subject['doesnt_exist'].should be_nil
    end
    
    it "merges new values" do
      subject.update(complex_header)
      subject['name1'].should eq 'other_value'
      subject['name2'].should eq 'value2'
    end
    
    it "overwrites existing values" do
      subject.update(simple_header)
      subject['name1'].should eq 'value1'
    end
  end
  
end