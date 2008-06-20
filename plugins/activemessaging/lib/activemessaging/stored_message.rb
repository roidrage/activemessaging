class ActiveMessaging::StoredMessage < ActiveRecord::Base
  set_table_name 'stored_messages'
  serialize :message
  serialize :headers
  
  def self.store!(destination, message, headers)
    stored_message = self.new :destination => destination.to_s, :message => message, :headers => headers
    stored_message.save!
  end
end