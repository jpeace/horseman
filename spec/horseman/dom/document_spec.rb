require 'horseman/dom/document'

describe Horseman::Dom::Document do
	include Mocks
	
	subject { described_class.new(html) }
  
  it "parses forms" do
    subject.forms.count.should eq 3

    subject.forms[:form1].id.should eq 'form1'
    subject.forms[:form1].action.should eq 'action'

    subject.forms[:form2].id.should eq 'form2'
    subject.forms[:form2].action.should eq 'http://www.anotherdomain.com/action'
    
    subject.forms[:form3].id.should eq 'form3'
    subject.forms[:form3].action.should eq ''
  end
  
  it "parses form fields" do
    subject.forms[:form1].fields.count.should eq 4

    subject.forms[:form1].fields[:text].name.should eq 'text'
    subject.forms[:form1].fields[:text].type.should eq :text
    subject.forms[:form1].fields[:text].value.should eq 'value1'
    
    subject.forms[:form1].fields[:check].name.should eq 'check'
    subject.forms[:form1].fields[:check].type.should eq :checkbox
    subject.forms[:form1].fields[:check].value.should eq 'value2'
    
    subject.forms[:form1].fields[:hidden].name.should eq 'hidden'
    subject.forms[:form1].fields[:hidden].type.should eq :hidden
    subject.forms[:form1].fields[:hidden].value.should eq 'value3'
  end
  
  it "recognizes submit fields" do
    subject.forms[:form1].submit.name.should eq 'submit1'
    subject.forms[:form2].submit.name.should eq 'submit2'
  end
  
  it "recognizes encoding types on forms" do
    subject.forms[:form1].encoding = :multipart
    subject.forms[:form2].encoding = :url
  end
  
  context "with missing form ids" do
    subject { described_class.new('<form></form><form id="form"></form>')}
    it "ignores forms without ids" do
      subject.forms.count.should eq 1
      subject.forms[:form].id.should eq 'form'
    end
  end
  
  context "with missing field names" do
    subject { described_class.new('<form id="form"><input name="input1" /><input /></form>')}
    it "ignores fields without names" do
      subject.forms[:form].fields.count.should eq 1
      subject.forms[:form].fields[:input1].name.should eq 'input1'
    end
  end	
end