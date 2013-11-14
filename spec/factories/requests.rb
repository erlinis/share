# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :request do
    receiver_id 1
    is_accepted nil
    association :user
  end
end
