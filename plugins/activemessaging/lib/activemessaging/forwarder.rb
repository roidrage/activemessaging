require 'activemessaging/stored_message'

module ActiveMessaging
  class Forwarder
    attr_accessor :logger
    
    def initialize
      @logger = ActiveMessaging.logger
    end
    
    def forward(message)
      ActiveMessaging::StoredMessage.transaction do
        ActiveMessaging::Gateway.deliver_message(message.destination.to_sym, message.message, message.headers)
        logger.info("Recovered message for destination #{message.destination.to_s}")
        message.destroy
      end
    rescue Exception => ex
      # TODO more specific error handling
      logger.error("Error during recovery of message #{e}")
    end
    
    def check_and_resend_queued
      return unless ActiveMessaging::StoredMessage.count > 0
      while message = ActiveMessaging::StoredMessage.find(:first)
        forward(message)
      end
    end
    
    def self.run
      self.new.check_and_resend_queued
    end
  end
end