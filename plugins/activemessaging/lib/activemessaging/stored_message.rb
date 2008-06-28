class ActiveMessaging::StoredMessage < ActiveRecord::Base
  set_table_name 'stored_messages'
  serialize :message
  serialize :headers
  
  def self.store!(destination, message, headers)
    stored_message = self.new :destination => destination.to_s, :message => message, :headers => headers
    stored_message.save
    stored_message
  end
  
  def self.count_undelivered
    count("*", :conditions => ["delivered = ? and active = ?", false, false])
  end
  
  def active!
    update_attributes(:active => true)
  end
  
  def delivered!
    update_attributes(:delivered => true)
  end
  
  def self.find_next_undelivered
    find(:first, :conditions => ["delivered = ? and active = ?", false, false])
  end
end