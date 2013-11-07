# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:random_message) {|n| LoremIpsum.generate }

  factory :user_message do
    message :random_message
  end

  factory :invalid_user_message, parent: :user_message do
    message nil
  end

  factory :user_message_with_image, parent: :user_message do
    message "message with image"
    image File.open(File.join(Rails.root, '/spec/fixtures/files/image_allowed_ext.jpeg'))
  end

  factory :user_message_with_image_not_allowed_ext, parent: :user_message do
    message :random_message
    image File.open(File.join(Rails.root, '/spec/fixtures/files/image_not_allowed_ext.bmp'))
  end

end

