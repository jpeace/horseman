require "horseman/action"
require "uri"

describe Horseman::Action do
  
  context "when given a URL without a query string" do
    subject {described_class.new(URI.parse("http://www.example.com/path/file.html"))}
  
    it "provides access to full URL" do
      expect(subject.url).to eq "http://www.example.com/path/file.html"
    end
  
    it "provides access to a relative path root" do
      expect(subject.relative_root).to eq "http://www.example.com/path/"
    end
  end
  
  context "when given a URL with a query string" do
    subject {described_class.new(URI.parse("http://www.example.com/path/file.html?q1=value"))}
  
    it "provides access to full URL" do
      expect(subject.url).to eq "http://www.example.com/path/file.html?q1=value"
    end
  
    it "provides access to a relative path root" do
      expect(subject.relative_root).to eq "http://www.example.com/path/"
    end
  end
  
end
