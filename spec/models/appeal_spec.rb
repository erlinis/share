require 'spec_helper'

describe Appeal do
  it { should belong_to :user }
  it { should belong_to :receiver }
  it { should validate_presence_of :receiver_id }

  before :each do
  	@user = FactoryGirl.create(:user)
  end

  it "does not allow to send a request twice for the same user if pending" do
    receiver = FactoryGirl.create(:user)
  	appeal = FactoryGirl.create(:appeal, user: @user, receiver_id: receiver.id)
  	appeal2 = FactoryGirl.build(:appeal, user: @user, receiver_id: receiver.id)
  	appeal2.should_not be_valid
    appeal2.should have(1).error_on(:receiver_id)
  end

  it "doesnot allow to send a request to an friend" do
    receiver = FactoryGirl.create(:user)
    appeal = FactoryGirl.create(:appeal, user: @user, receiver_id: receiver.id, is_accepted: true)
    appeal2 = FactoryGirl.build(:appeal, user: @user, receiver_id: receiver.id)
    appeal2.should_not be_valid
    appeal2.should have(1).error_on(:receiver_id)
  end

  it "does not allow to add myself as a friend" do
  	appeal = FactoryGirl.build(:appeal, user: @user, receiver_id: @user.id)
  	appeal.should_not be_valid
    appeal.should have(1).error_on(:receiver_id)
  end

  it "validates the existence of receiver" do
    receiver = FactoryGirl.create(:user)
    appeal = FactoryGirl.build(:appeal, user: @user, receiver_id: 1)
    appeal.should_not be_valid
  end
end
