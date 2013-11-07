class AddImageToUserMessage < ActiveRecord::Migration
  def change
    add_column :user_messages, :image, :string
  end
end
