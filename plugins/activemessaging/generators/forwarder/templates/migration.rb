class CreateActiveMessagingStoredMessage < ActiveRecord::Migration
  def self.up
    create_table "stored_messages", :force => true do |t|
      t.column :destination, :string
      t.column :message, :text
      t.column :headers, :text
    end
  end

  def self.down
    drop_table "stored_messages"
  end
end