# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_message do
    message "some message"
  end

  factory :invalid_user_message, parent: :user_message do
    message nil
  end
end



# FactoryGirl.build :user_message