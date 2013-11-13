class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :sender_id, references: :users
      t.integer :receiver_id, references: :users
      t.boolean :is_accepted, default: true

      t.timestamps
    end
  end
end
