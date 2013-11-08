require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:name) }
  it { should_not validate_presence_of(:profile_picture) }

  it "should avoid two users with the same email" do
    user = FactoryGirl.create(:user)
    user_same_email = FactoryGirl.build(:user)
    user_same_email.valid?.should == false
    user_same_email.errors[:email] != nil
  end

  it "should be a valid email" do
    user = FactoryGirl.create(:user)
    user.email = 'userfoo.org'
    user.should be_valid
  end
 
  it "should not be a valid email" do
    user = FactoryGirl.create(:user)
    user.email = 'user_at_foo.org'
    user.should_not be_valid
  end


end
