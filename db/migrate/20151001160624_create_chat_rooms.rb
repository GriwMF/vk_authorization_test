class CreateChatRooms < ActiveRecord::Migration
  def change
    create_table :chat_rooms do |t|
      t.string :chat_id
      t.string :bot_id

      t.timestamps null: false
    end

    add_index :chat_rooms, :bot_id
  end
end
