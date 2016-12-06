require 'helper'

class LogglyOutputTest < Test::Unit::TestCase
  LOGGLY_LISTEN_PORT = 3001

  CONFIG = %[
    loggly_url http://localhost:#{LOGGLY_LISTEN_PORT}/
  ]

  def setup
    Fluent::Test.setup
    dummy_server
  end

  def create_driver(conf = CONFIG, tag = 'test')
    Fluent::Test::OutputTestDriver.new(Fluent::LogglyOutput, tag).configure(conf)
  end

  def test_configure
    d = create_driver
    assert_equal "http://localhost:#{LOGGLY_LISTEN_PORT}/", d.instance.loggly_url
  end

  def test_emit
    d = create_driver
    d.instance.start
    d.emit({"message" => "test"})
    d.run

    assert_equal '{"message":"test"}', @posted[0][:message]
  end

  def dummy_server
    @posted = []
    @prohibited = 0
    @auth = false
    @dummy_server_thread = Thread.new do
      logger = WEBrick::Log.new('/dev/null', WEBrick::BasicLog::DEBUG)
      srv = WEBrick::HTTPServer.new({BindAddress: '127.0.0.1', Port: LOGGLY_LISTEN_PORT, Logger: logger, AccessLog: []})
      begin
        srv.mount_proc('/') { |req,res|
          res.status = 200
          res.body = 'running'
          post_param = CGI.parse(req.body)
          @posted.push({message: req.body})
        }
        srv.start
      ensure
        srv.shutdown
      end
    end
    # to wait completion of dummy server.start()
    require 'thread'
    cv = ConditionVariable.new
    _dummy_server_watcher = Thread.new {
      connected = false
      while not connected
        begin
          get_content('localhost', LOGGLY_LISTEN_PORT, '/')
          connected = true
        rescue Errno::ECONNREFUSED
          sleep 0.1
        rescue StandardError => e
          p e
          sleep 0.1
        end
      end
      cv.signal
    }
    mutex = Mutex.new
    mutex.synchronize {
      cv.wait(mutex)
    }
  end

  def teardown
    @dummy_server_thread.kill
    @dummy_server_thread.join
  end
end
