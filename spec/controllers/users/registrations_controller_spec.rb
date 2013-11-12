require 'spec_helper'

describe Users::RegistrationsController do

  context "without an authenticated user " do
    it "should have a current_user" do
      subject.current_user.should be_nil
    end
  end

  context "with an authenticated user " do
    login_user

    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end
  end

end