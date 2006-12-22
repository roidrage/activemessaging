
ActiveMessaging::Gateway.define do |s|
  s.queue :hello_world, '/queue/helloWorld'
end
