require "spec_helper"

describe NewNotificationMailer do
  describe "new_friendship_request" do
    let(:mail) { NewNotificationMailer.new_friendship_request }

    it "renders the headers" do
      mail.subject.should eq("New friendship request")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
