# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :appeal do
    association :receiver, factory: :user
    is_accepted nil
    association :user, factory: :user
  end
end
