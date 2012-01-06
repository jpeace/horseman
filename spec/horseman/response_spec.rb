require 'horseman/response'

describe Horseman::Response do
  include Mocks
  
  subject { described_class.new(html) }
  
  it "parses forms" do
    subject.forms.count.should eq 2
    subject.forms[0].id.should eq 'form1'
    subject.forms[1].id.should eq 'form2'
  end
end