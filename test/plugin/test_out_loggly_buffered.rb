require 'helper'

class LogglyOutputBufferedTest < Test::Unit::TestCase
  LOGGLY_LISTEN_PORT = 3001

  CONFIG = %[
    loggly_url http://localhost:#{LOGGLY_LISTEN_PORT}/
  ]

  def setup
    Fluent::Test.setup
  end

  def create_driver(conf = CONFIG, tag = 'test')
    Fluent::Test::OutputTestDriver.new(Fluent::LogglyOutputBuffered, tag).configure(conf)
  end

  def test_configure
    d = create_driver
    assert_equal "http://localhost:#{LOGGLY_LISTEN_PORT}/", d.instance.loggly_url
    assert_equal true, d.instance.output_include_time
    assert_equal 0, d.instance.time_precision_digits
  end
end
