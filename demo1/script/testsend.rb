load File.dirname(__FILE__) + '/../config/environment.rb'

#
# For some reason I need to put the include etc. into a class to get it to work
#
class DemoSender
  include ActiveMessaging::MessageSender

  publishes_to :hello_world

  def send count
    count.times do |i|
      publish :hello_world, "Hello World in Rails: #{i}"
    end
    puts "Sent"
  end
end

sender = DemoSender.new
sender.send 100 