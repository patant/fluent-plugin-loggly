require 'helper'

class LogglyOutputTest < Test::Unit::TestCase
  LOGGLY_LISTEN_PORT = 3001

  CONFIG = %[
    loggly_url http://localhost:#{LOGGLY_LISTEN_PORT}/
  ]

  def setup
    Fluent::Test.setup
  end

  def create_driver(conf = CONFIG, tag = 'test')
    Fluent::Test::OutputTestDriver.new(Fluent::LogglyOutput, tag).configure(conf)
  end

  def stub_loggly
    stub_request(:post, "http://localhost:#{LOGGLY_LISTEN_PORT}/")
  end

  def test_configure
    d = create_driver
    assert_equal "http://localhost:#{LOGGLY_LISTEN_PORT}/", d.instance.loggly_url
  end

  def test_emit
    stub_loggly
    d = create_driver
    d.instance.start
    d.emit({"message" => "test"})
    d.run

    assert_requested :post, "http://localhost:#{LOGGLY_LISTEN_PORT}/",
                     body: '{"message":"test"}',
                     times: 1
  end
end
