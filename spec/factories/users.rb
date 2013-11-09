# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user do
    name "Erlinis Quintana"
    password "erlinis1129"
    password_confirmation "erlinis1129"
    sequence(:email) {|n| "person#{n}@example.com" }
    profile_picture nil
  end

  factory :user2, parent: :user do
    name "Santiago Baez"
    password "santiago123"
    password_confirmation "santiago123"
    profile_picture nil
  end
end
