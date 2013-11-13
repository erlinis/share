
class UserMessage < ActiveRecord::Base
  
  attr_accessible :message, :image, :remote_image_url, :remove_image
  mount_uploader :image, ImageUploader

  validates :message, presence: true, length: { maximum: 140 }
  validates_with UniqueMessageValidator
  validates :user, :presence => true

  # Relationships
  belongs_to :user

  before_destroy :remove_image
  after_destroy :remove_id_directory

  def remove_id_directory
    FileUtils.remove_dir("#{Rails.root}/public/#{ImageUploader.store_dir}/user_message/image/#{self.id}", :force => true)
  end

end
