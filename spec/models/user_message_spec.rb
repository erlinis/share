require 'spec_helper'

describe UserMessage do
  it { should validate_presence_of(:message) }
  it { should ensure_length_of(:message).is_at_most(140) }

  it "should not create a repeated message " do
      @user_message = FactoryGirl.create(:user_message, message: "text")
      @user_message_repeated = FactoryGirl.build(:user_message, message: "text")
      @user_message_repeated.valid?.should == false
  end
end
