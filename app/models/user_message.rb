
class UserMessage < ActiveRecord::Base
  
  attr_accessible :message, :image, :remote_image_url
  mount_uploader :image, ImageUploader

  validates :message, presence: true, length: { maximum: 140 }
  validates_with UniqueMessageValidator

end
