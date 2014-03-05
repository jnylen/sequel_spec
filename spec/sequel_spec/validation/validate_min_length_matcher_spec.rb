require 'spec_helper'

describe "validate_min_length_matcher" do
  before do
    define_model :item do
      plugin :validation_helpers

      def validate
        validates_min_length 4, :name, :allow_nil => true
      end
    end
  end

  subject{ Item }

  describe "arguments" do
    it "should require attribute" do
      expect {
        @matcher = validate_min_length
      }.to raise_error(ArgumentError)
    end
    it "should require additionnal parameters" do
      expect {
        @matcher = validate_min_length :name
      }.to raise_error(ArgumentError)
    end
    it "should refuse invalid additionnal parameters" do
      expect {
        @matcher = validate_min_length :id, :name
      }.to raise_error(ArgumentError)
    end
    it "should accept valid additionnal parameters" do
      expect {
        @matcher = validate_min_length 4, :name
      }.not_to raise_error
    end
  end

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = validate_min_length 4, :name
        @matcher.description.should == "validate length of :name is greater than or equal to 4"
      end
      it "should set failure messages" do
        @matcher = validate_min_length 4, :name
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end
    end
    describe "with options" do
      it "should contain a description" do
        @matcher = validate_min_length 4, :name, :allow_nil => true
        @matcher.description.should == "validate length of :name is greater than or equal to 4 with option(s) :allow_nil => true"
      end
      it "should set failure messages" do
        @matcher = validate_min_length 4, :price, :allow_nil => true
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end
      it "should explicit used options if different than expected" do
        @matcher = validate_min_length 4, :name, :allow_blank => true
        @matcher.matches? subject
        explanation = " but called with option(s) :allow_nil => true instead"
        @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
      end
      it "should warn if invalid options are used" do
        @matcher = validate_min_length 4, :name, :allow_anything => true
        @matcher.matches? subject
        explanation = " but option :allow_anything is not valid"
        @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
      end
    end
  end

  describe "matchers" do
    it{ should validate_min_length(4, :name) }
    it{ should validate_min_length(4, :name, :allow_nil => true) }
    it{ should_not validate_min_length(4, :price) }
    it{ should_not validate_min_length(3, :name) }
    it{ should_not validate_min_length(4, :name, :allow_blank => true) }
  end
end
