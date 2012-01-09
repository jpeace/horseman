require 'horseman/response'

describe Horseman::Response do
  include Mocks
  
  subject { described_class.new(html) }
  
  it "parses forms" do
    subject.forms.count.should eq 2
    subject.forms[0].id.should eq 'form1'
    subject.forms[1].id.should eq 'form2'
  end
  
  it "parses form fields" do
    subject.forms[0].fields.count.should eq 3

    subject.forms[0].fields[0].name.should eq 'text'
    subject.forms[0].fields[0].type.should eq :text
    subject.forms[0].fields[0].value.should eq 'value1'
    
    subject.forms[0].fields[1].name.should eq 'check'
    subject.forms[0].fields[1].type.should eq :checkbox
    subject.forms[0].fields[1].value.should eq 'value2'
    
    subject.forms[0].fields[2].name.should eq 'hidden'
    subject.forms[0].fields[2].type.should eq :hidden
    subject.forms[0].fields[2].value.should eq 'value3'
  end
  
  it "recognizes submit fields" do
    subject.forms[0].submit.name.should eq 'submit1'
    subject.forms[1].submit.name.should eq 'submit2'
  end
  
  it "recognizes encoding types on forms" do
    subject.forms[0].encoding = :multipart
    subject.forms[1].encoding = :url
  end
end