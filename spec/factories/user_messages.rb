# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:random_message) {|n| LoremIpsum.generate }

  factory :user_message do
    message :random_message
  end

  factory :invalid_user_message, parent: :user_message do
    message nil
  end
  
end

