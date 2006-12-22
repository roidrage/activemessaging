class HelloWorldProcessor < ActiveMessaging::Processor
  
  subscribes_to :hello_world
  
  def on_message(message)
    puts "received: " + message.body
  end
  
end
