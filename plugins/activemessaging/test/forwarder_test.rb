require File.dirname(__FILE__) + '/test_helper'
require 'rubygems'
require 'mocha'
require 'activemessaging/forwarder'

class ForwarderTest < Test::Unit::TestCase

  def setup
    @forwarder = ActiveMessaging::Forwarder.new
    ActiveMessaging::Gateway.store_and_forward_to :test
    ActiveMessaging::Gateway.destination :hello_world, '/queue/helloWorld' rescue nil
    ActiveMessaging::StoredMessage.delete_all
  end
  
  def test_publish_should_check_and_resend_queued_messages
    ActiveMessaging::StoredMessage.store!("hello_world", "hello, world", {:keep_it => "real"})
    ActiveMessaging::Gateway.connection('default').expects(:send)
    @forwarder.forward ActiveMessaging::StoredMessage.find(:first)
  end

  def test_check_and_resend_should_empty_the_queue
    ActiveMessaging::StoredMessage.store!("hello_world", "hello, world", {:keep_it => "real"})
    @forwarder.check_and_resend_queued
    assert_equal 0, ActiveMessaging::StoredMessage.count
  end
end