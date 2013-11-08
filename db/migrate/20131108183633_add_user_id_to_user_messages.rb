class AddUserIdToUserMessages < ActiveRecord::Migration
  def change
    add_column :user_messages, :user_id, :integer
  end
end
