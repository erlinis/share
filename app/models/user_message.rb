
class UserMessage < ActiveRecord::Base
  attr_accessible :message

  validates :message, presence: true, 
                      length: { maximum: 140 }, 
                      uniqueness: { scope: :created_at}

end
