require "spec_helper"

describe NewNotificationMailer do
  
  describe "new_appeal" do
    let(:current_user) { FactoryGirl.create(:user, email: "user@example.com")}
    let(:receiver) { FactoryGirl.create(:user, email: "receiver@example.com")}
    let(:appeal) { FactoryGirl.create(:appeal, receiver: receiver) }
    let(:mail) { NewNotificationMailer.new_appeal(current_user, receiver) }

    it "renders the subject" do
      mail.subject.should eq("Someone want be your friend!")
    end

    it "renders the receiver email" do
      mail.to.should eq(["receiver@example.com"])
    end

    it "renders the sender email" do
      mail.from.should eq(["notifications@share.com"])
    end

    it "renders in body who receive the mail" do
       mail.body.encoded.should include("Hello #{receiver.name} ,")
    end

    it "renders in body who send the request" do
       mail.body.encoded.should include("#{current_user.name} wants be your friend")
    end
  end

  describe "appeal_accepted" do
    let(:current_user) { FactoryGirl.create(:user, email: "user@example.com")}
    let(:receiver) { FactoryGirl.create(:user, email: "receiver@example.com")}
    let(:appeal) { FactoryGirl.create(:appeal, user: current_user, receiver: receiver ) }
    let(:mail) { NewNotificationMailer.appeal_accepted(current_user, receiver) }

    it "renders the subject" do
      mail.subject.should eq("You have a new friend")
    end

    it "renders the receiver email" do
      mail.to.should eq(["user@example.com"])
    end

    it "renders the sender email" do
      mail.from.should eq(["notifications@share.com"])
    end

    it "renders in body who receive the mail" do
       mail.body.encoded.should include("Hello #{current_user.name}")
    end

    it "renders in body who send the request" do
       mail.body.encoded.should include("#{receiver.name} accepted be your friend")
    end
  end
end
