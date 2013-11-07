require 'spec_helper'

describe UserMessage do
  it { should validate_presence_of(:message) }
  it { should ensure_length_of(:message).is_at_most(140) }

  it "should not create a repeated message " do
    @user_message = FactoryGirl.create(:user_message, message: "text")
    @user_message_repeated = FactoryGirl.build(:user_message, message: "text")
    @user_message_repeated.valid?.should == false
  end

  it "should permit update a user_message with same text" do 
    @user_message = FactoryGirl.create(:user_message, message: "initial message")
    @user_message.message = "initial message"
    @user_message.valid?.should == true
  end

  it "should create a user_message with image" do
    @user_message = FactoryGirl.build(:user_message_with_image)
    @user_message.valid?.should == true
  end

  it "should no create a user message file with not allowed ext" do
    @user_message = FactoryGirl.build(:user_message_with_image_not_allowed_ext) 
    @user_message.valid?.should == false

    @user_message.errors.full_messages.each do | message |
        puts "message: #{message}" 
    end

  end
end
