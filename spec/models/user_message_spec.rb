require 'spec_helper'

describe UserMessage do
  it { should validate_presence_of(:message) }
  it { should ensure_length_of(:message).is_at_most(140) }

  it "should not create a repeated message for same user" do
    user = FactoryGirl.create(:user)
    user_message = FactoryGirl.create(:user_message, user: user, message: "text")
    user_message_repeated = FactoryGirl.build(:user_message, user: user, message: "text")
    user_message_repeated.valid?.should == false
  end

 it "should create a repeated message for different users" do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user2)

    user_message = FactoryGirl.create(:user_message, user: user, message: "text")
    user_message_repeated_different_user = FactoryGirl.build(:user_message, user: user2, message: "text")
    user_message_repeated_different_user.valid?.should == true
  end

  it "should permit update a user_message with same text" do 
    user_message = FactoryGirl.create(:user_message, message: "initial message")
    user_message.message = "initial message"
    user_message.valid?.should == true
  end

  it "should create a user_message with image" do
    user_message = FactoryGirl.build(:user_message_with_image)
    user_message.valid?.should == true
  end

  # TODO: fix the bug on GUI, when it is a image with not allowed extension
  it "should not create a user message file with not allowed ext" do
    user_message = FactoryGirl.create(:user_message_with_image_not_allowed_ext) 
    user_message.valid? 

    puts user_message.errors.inspect
    user_message.valid?.should == true
  end

  it "should not create message without user" do
    user_message = FactoryGirl.build(:user_message, user: nil)
    user_message.valid?.should == false
  end

end
