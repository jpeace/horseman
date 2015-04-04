require "horseman/dom/document"

describe Horseman::Dom::Document do
	include Mocks
	
	subject { described_class.new(html) }
  
	context "when parsing forms" do
		it "finds all forms" do
	    subject.forms.count.should eq 3

	    subject.forms[:form1].id.should eq "form1"
	    subject.forms[:form1].action.should eq "action"

	    subject.forms[:form2].id.should eq "form2"
	    subject.forms[:form2].action.should eq "http://www.anotherdomain.com/action"
	    
	    subject.forms[:form3].id.should eq "form3"
	    subject.forms[:form3].action.should eq ""
	  end
	  
	  it "parses form fields" do
	    subject.forms[:form1].fields.count.should eq 4

	    subject.forms[:form1].fields[:text].name.should eq "text"
	    subject.forms[:form1].fields[:text].type.should eq :text
	    subject.forms[:form1].fields[:text].value.should eq "value1"
	    
	    subject.forms[:form1].fields[:check].name.should eq "check"
	    subject.forms[:form1].fields[:check].type.should eq :checkbox
	    subject.forms[:form1].fields[:check].value.should eq "value2"
	    
	    subject.forms[:form1].fields[:hidden].name.should eq "hidden"
	    subject.forms[:form1].fields[:hidden].type.should eq :hidden
	    subject.forms[:form1].fields[:hidden].value.should eq "value3"
	  end
	  
	  it "recognizes submit fields" do
	    subject.forms[:form1].submit.name.should eq "submit1"
	    subject.forms[:form2].submit.name.should eq "submit2"
	  end
	  
	  it "recognizes encoding types on forms" do
	    subject.forms[:form1].encoding = :multipart
	    subject.forms[:form2].encoding = :url
	  end

	  context "with missing form ids" do
	    subject { described_class.new(%{<form></form><form id="form"></form>}) }
	    it "ignores forms without ids" do
	      subject.forms.count.should eq 1
	      subject.forms[:form].id.should eq "form"
	    end
	  end
	  
	  context "with missing field names" do
	    subject { described_class.new(%{<form id="form"><input name="input1" /><input /></form>})}
	    it "ignores fields without names" do
	      subject.forms[:form].fields.count.should eq 1
	      subject.forms[:form].fields[:input1].name.should eq "input1"
	    end
	  end	
	end

  
  context "when parsing script blocks" do
  	context "without a src reference" do
  		subject { described_class.new(%{<script type="text/javascript">alert("test");</script>}) }

  		it "uses the body" do
  			subject.scripts.first.body.should eq %{alert("test");}
  		end
  	end

  	context "with a src reference" do
  		subject { described_class.new(%{<script type="text/javascript" src="http://www.example.com/script.js"></script>}) }

  		it "downloads the script" do
  		 	subject.scripts.first.body.should eq %{alert("downloaded");}
  		end
  	end

  	it "finds all valid blocks in order" do
  		subject.scripts.count.should eq 3

  		subject.scripts[0].body.should eq %{alert("downloaded");}
  		subject.scripts[1].body.should eq %{alert("hello");}
  		subject.scripts[2].body.should eq %{alert("no type");}
  	end
  end

  context "when parsing frames" do
    it "creates a sub-document" do
      subject.frames[:frame1].is_a? Horseman::Dom::Document
    end

    it "correctly parses the sub-document" do
      subject.frames[:frame1].forms.count.should eq 1
      subject.frames[:frame1].forms[:form1].fields.count.should eq 4
    end
  end

end