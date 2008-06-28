module ActiveMessaging
  class Forwarder
    def forward(message)
      ActiveMessaging::StoredMessage.transaction do
        ActiveMessaging::Gateway.deliver_message(message.destination.to_sym, message.message, message.headers)
        message.destroy
      end
    end
    
    def check_and_resend_queued
      return unless ActiveMessaging::StoredMessage.count > 0
      messages = ActiveMessaging::StoredMessage.find_all_by_destination(destination.to_s)
      messages.each do |stored_message|
      end
    end
  end
end