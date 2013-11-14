class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :profile_picture, :remove_profile_picture

  mount_uploader :profile_picture, ProfilePictureUploader
  validates :name, presence: true

  # Relationships
  has_many :user_messages
  has_many :requests
  has_many :receivers, :through => :requests
end
