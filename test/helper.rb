require 'test/unit'
require 'webrick'
require 'net/http'
require 'cgi'
require 'fluent/test'
require 'fluent/plugin/out_loggly'
require 'fluent/plugin/out_loggly_buffered'

def get_content(server, port, path, headers={})
  require 'net/http'
  Net::HTTP.start(server, port){|http|
    http.get(path, headers).body
  }
end
