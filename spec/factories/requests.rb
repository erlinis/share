# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :request do
    sender_id 1
    receiver_id 1
    is_accepted false
  end
end
