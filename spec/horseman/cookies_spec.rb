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
    expect(subject).to be_empty
  end
  
  it "accepts a single header" do
    expect(subject.update(simple_header)['name1']).to eq 'value1' 
  end
  
  it "accepts multiple headers" do
    subject.update([simple_header, complex_header])
    expect(subject['name1']).to eq 'value1'
    expect(subject['name2']).to eq 'value2'
  end
  
  it "captures attributes" do
    subject.update(complex_header)
    expect(subject.get('name2').domain).to eq 'www.example.com'
    expect(subject.get('name2').path).to eq '/path'
    expect(subject.get('name2').expiration).to eq DateTime.new(2012, 1, 1, 0, 0, 0, 0)
  end
  
  it "accepts an empty array" do
    expect(subject.update([])).to be_empty
  end
  
  it "accepts nil" do
    expect(subject.update(nil)).to be_empty
  end
  
  it "raises an exception on an unrecognized header" do
    expect {subject.update('bad header')}.to raise_error(ArgumentError)
  end
  
  it "generates a correct header" do
    header = subject.update([simple_header, complex_header]).to_s
    expect(header).to match /\w+=\w+; \w+=\w+/
    expect(header).to match /name1=value1/
    expect(header).to match /name2=value2/
  end
  
  context "with prexisting values" do
    subject do
      described_class.new.update('name1=other_value')
    end
    
    it "returns nil for uninitialized values" do
      expect(subject['doesnt_exist']).to be_nil
    end
    
    it "merges new values" do
      subject.update(complex_header)
      expect(subject['name1']).to eq 'other_value'
      expect(subject['name2']).to eq 'value2'
    end
    
    it "overwrites existing values" do
      subject.update(simple_header)
      expect(subject['name1']).to eq 'value1'
    end
  end
  
end