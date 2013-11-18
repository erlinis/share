class Appeal < ActiveRecord::Base
  attr_accessible :is_accepted, :receiver_id

  belongs_to :user
  belongs_to :receiver, :class_name => "User"

	validates :receiver_id, presence: true
	validate :check_pending_appeal, :on => :create
  validate :self_appeal, :on => :create
  validate :user_exist

  private

  def check_pending_appeal
  	appeal = Appeal.where("user_id = :user and receiver_id = :receiver", user: user, receiver: self.receiver_id).first
  	if appeal.present? && appeal.is_accepted == nil
  		errors.add(:receiver_id, "You have a request Pending for approval right now for this user")
  	end
  end

  def self_appeal
    if user == self.receiver_id
      errors.add(:receiver_id, "You can send a request yo yourself")
    end
  end

  def user_exist
    begin
      user = User.find(self.receiver_id)
    rescue
      errors.add(:receiver_id, "This user doesn't exist")
    end
  end

end
