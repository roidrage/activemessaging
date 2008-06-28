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
      logger.error("Error during recovery of message (Error: #{e})")
      # jump out of the loop, it seems delivering more messages is of no use
      raise
    end
    
    def check_and_resend_queued
      return unless ActiveMessaging::StoredMessage.count > 0
      logger.info "Running recovery at #{Time.now}"
      while message = ActiveMessaging::StoredMessage.find(:first)
        forward(message)
      end
    end
    
    def self.run
      self.new.check_and_resend_queued rescue nil
    end
    
    def self.daemonize
      while true
        self.run
        sleep 60
      end
    end
  end
end