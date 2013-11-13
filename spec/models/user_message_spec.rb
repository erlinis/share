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

  it "should not create a user message when a file has a not allowed ext" do
    pending("test pass but there is a bug on GUI/controller, when it is a image with not allowed extension isnt doesnt raise any error ") do
      user_message = FactoryGirl.create(:user_message_with_image_not_allowed_ext) 
      user_message.valid? 
      #puts user_message.errors.inspect
      user_message.valid?.should == false
    end
  end

  context "when a messages with image is destroyed" do
    before(:each) do
      @user_message_with_image = FactoryGirl.create(:user_message_with_image)
      @user_message_with_image.destroy
    end

    it "should delete the image when the user_message is destroyed" do
      expect{
        imagen_path = "/spec/fixtures/uploads/#{@user_message_with_image.image}"
        File.open(File.join(Rails.root, imagen_path))
      }.to raise_error(Errno::ENOENT)
    end

    it "should delete the directory image when the user_message is destroyed" do
      expect{
        dir_path = "/spec/fixtures/uploads/user_message/image/#{@user_message_with_image.id}/"
        Dir.chdir(File.join(Rails.root, dir_path))
      }.to raise_error(Errno::ENOENT)
    end
  end

  it "should not create message without user" do
    user_message = FactoryGirl.build(:user_message, user: nil)
    user_message.valid?.should == false
  end


end
