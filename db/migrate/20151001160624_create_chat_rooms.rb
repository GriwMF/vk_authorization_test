class CreateChatRooms < ActiveRecord::Migration
  def change
    create_table :chat_rooms do |t|
      t.string :chat_id
      t.string :bot_id
      t.string :user_id

      t.timestamps null: false
    end

    add_index :chat_rooms, [:user_id, :bot_id]
  end
end
