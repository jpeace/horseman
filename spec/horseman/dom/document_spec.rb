require 'horseman/dom/document'

describe Horseman::Dom::Document do
	include Mocks
	
	subject { described_class.new(html) }
  
  it "parses forms" do
    subject.forms.count.should eq 3

    subject.forms[0].id.should eq 'form1'
    subject.forms[0].action.should eq 'action'

    subject.forms[1].id.should eq 'form2'
    subject.forms[1].action.should eq 'http://www.anotherdomain.com/action'
    
    subject.forms[2].id.should eq 'form3'
    subject.forms[2].action.should eq ''
  end
  
  it "parses form fields" do
    subject.forms[0].fields.count.should eq 4

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
  
  context "with missing form ids" do
    subject { described_class.new('<form></form><form id="form"></form>')}
    it "ignores forms without ids" do
      subject.forms.count.should eq 1
      subject.forms[0].id.should eq 'form'
    end
  end
  
  context "with missing field names" do
    subject { described_class.new('<form id="form"><input name="input1" /><input /></form>')}
    it "ignores fields without names" do
      subject.forms[0].fields.count.should eq 1
      subject.forms[0].fields[0].name.should eq 'input1'
    end
  end	
end