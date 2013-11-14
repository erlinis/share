require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:name) }
  it { should_not validate_presence_of(:profile_picture) }
  it { should have_many :requests }
  it { should have_many(:receivers).through(:requests) }

  it "should avoid two users with the same email" do
    user = FactoryGirl.create(:user, email: "foo@org.com")
    user_same_email = FactoryGirl.build(:user, email: "foo@org.com")
    user_same_email.valid?.should == false
    user_same_email.errors[:email] != nil
  end

  it "should not be a valid email" do
    user = FactoryGirl.build(:user, email: "user_at_foo.org")
    user.should_not be_valid
  end

end
