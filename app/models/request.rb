class Request < ActiveRecord::Base
  attr_accessible :is_accepted, :receiver_id, :sender_id
end
