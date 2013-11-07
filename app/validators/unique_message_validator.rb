class UniqueMessageValidator < ActiveModel::Validator
  def validate(record)
    item = UserMessage.where('message = :message and created_at >= :date', message: record.message, date: Date.current).first
    if item && item.created_at.strftime("%Y-%m-%d").eql?(Date.current.strftime("%Y-%m-%d"))
      record.errors.add( :message, "You can't write a same message twice a day")
    end
  end
end
