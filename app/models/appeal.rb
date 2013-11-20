class Appeal < ActiveRecord::Base
  attr_accessible :is_accepted, :receiver_id

  belongs_to :user
  belongs_to :receiver, :class_name => "User"

	validates :receiver_id, presence: true
	validate :check_pending_appeal, :on => :create
  validate :self_appeal, :on => :create
  validate :user_exist

  after_save :send_notification

  private

  def check_pending_appeal
  	appeal = Appeal.where("user_id = :user and receiver_id = :receiver", user: user, receiver: self.receiver_id).first
  	if appeal.present? && appeal.is_accepted == nil
  		errors.add(:receiver_id, "You have a request Pending for approval right now for this user")
  	end
  end

  def self_appeal
    if user == receiver
      errors.add(:receiver_id, "You can't send a request to yourself")
    end
  end

  def user_exist
    begin
      user = User.find(self.receiver_id)
    rescue
      errors.add(:receiver_id, "This user doesn't exist")
    end
  end

  def send_notification
    if self.is_accepted
      NewNotificationMailer.appeal_accepted(self.user, self.receiver).deliver
    end
  end

end
