require "horseman/dom/document"

describe Horseman::Dom::Document do
	include Mocks
	
	subject { described_class.new(html) }
  
	context "when parsing forms" do
		it "finds all forms" do
	    expect(subject.forms.count).to eq 3

	    expect(subject.forms[:form1].id).to eq "form1"
	    expect(subject.forms[:form1].action).to eq "action"

	    expect(subject.forms[:form2].id).to eq "form2"
	    expect(subject.forms[:form2].action).to eq "http://www.anotherdomain.com/action"
	    
	    expect(subject.forms[:form3].id).to eq "form3"
	    expect(subject.forms[:form3].action).to eq ""
	  end
	  
	  it "parses form fields" do
	    expect(subject.forms[:form1].fields.count).to eq 4

	    expect(subject.forms[:form1].fields[:text].name).to eq "text"
	    expect(subject.forms[:form1].fields[:text].type).to eq :text
	    expect(subject.forms[:form1].fields[:text].value).to eq "value1"
	    
	    expect(subject.forms[:form1].fields[:check].name).to eq "check"
	    expect(subject.forms[:form1].fields[:check].type).to eq :checkbox
	    expect(subject.forms[:form1].fields[:check].value).to eq "value2"
	    
	    expect(subject.forms[:form1].fields[:hidden].name).to eq "hidden"
	    expect(subject.forms[:form1].fields[:hidden].type).to eq :hidden
	    expect(subject.forms[:form1].fields[:hidden].value).to eq "value3"
	  end
	  
	  it "recognizes submit fields" do
	    expect(subject.forms[:form1].submit.name).to eq "submit1"
	    expect(subject.forms[:form2].submit.name).to eq "submit2"
	  end
	  
	  it "recognizes encoding types on forms" do
	    subject.forms[:form1].encoding = :multipart
	    subject.forms[:form2].encoding = :url
	  end

	  context "with missing form ids" do
	    subject { described_class.new(%{<form></form><form id="form"></form>}) }
	    it "ignores forms without ids" do
	      expect(subject.forms.count).to eq 1
	      expect(subject.forms[:form].id).to eq "form"
	    end
	  end
	  
	  context "with missing field names" do
	    subject { described_class.new(%{<form id="form"><input name="input1" /><input /></form>})}
	    it "ignores fields without names" do
	      expect(subject.forms[:form].fields.count).to eq 1
	      expect(subject.forms[:form].fields[:input1].name).to eq "input1"
	    end
	  end	
	end

  
  context "when parsing script blocks" do
  	context "without a src reference" do
  		subject { described_class.new(%{<script type="text/javascript">alert("test");</script>}) }

  		it "uses the body" do
  			expect(subject.scripts.first.body).to eq %{alert("test");}
  		end
  	end

  	context "with a src reference" do
  		subject { described_class.new(%{<script type="text/javascript" src="http://www.example.com/script.js"></script>}) }

  		it "downloads the script" do
  		 	expect(subject.scripts.first.body).to eq %{alert("downloaded");}
  		end
  	end

  	it "finds all valid blocks in order" do
  		expect(subject.scripts.count).to eq 3

  		expect(subject.scripts[0].body).to eq %{alert("downloaded");}
  		expect(subject.scripts[1].body).to eq %{alert("hello");}
  		expect(subject.scripts[2].body).to eq %{alert("no type");}
  	end
  end

  context "when parsing frames" do
    it "creates a sub-document" do
      subject.frames[:frame1].is_a? Horseman::Dom::Document
    end

    it "correctly parses the sub-document" do
      expect(subject.frames[:frame1].forms.count).to eq 1
      expect(subject.frames[:frame1].forms[:form1].fields.count).to eq 4
    end
  end

end