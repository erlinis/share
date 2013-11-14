class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_id, references: :users
      t.integer :receiver_id, references: :users
      t.boolean :is_accepted

      t.timestamps
    end
  end
end
