require 'horseman/hidden_fields'

describe Horseman::HiddenFields do
  
  it "parses a single simple hidden input field" do
    html = %{<input type="hidden" name="test" value="test_data" />}
    cut = described_class.new(html)
    
    cut.tokens.size.should == 1
    cut.tokens['test'].should == 'test_data'
  end
  
  it "parses a single complex hidden input field" do
    html = %{<input attr0="value0" type="hidden" attr1="value1" name="test" attr2="value2" value="test_data" attr3="value3" />}
    cut = described_class.new(html)
    
    cut.tokens.size.should == 1
    cut.tokens['test'].should == 'test_data'
  end

  it "parses multiple hidden input fields" do
    html = %{
        <input type="hidden" name="test" value="test_data" />
        <input type="hidden" name="foo" value="bar" />
        <some other="tag"></some>
        <input type="hidden" name="dee" value="dum" />
            }
    cut = described_class.new(html)
    
    cut.tokens.size.should == 3
    cut.tokens['test'].should == 'test_data'
    cut.tokens['foo'].should == 'bar'
    cut.tokens['dee'].should == 'dum'
  end
    
  it "handles single quotes, too" do
    html = %{<input type='hidden' name='test' value='test_data' />}
    cut = described_class.new(html)
    
    cut.tokens.size.should == 1
    cut.tokens['test'].should == 'test_data'
  end
  
end