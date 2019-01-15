=begin

  Copyright (C) 2012 Patrik Antonsson

  Licensed to the Apache Software Foundation (ASF) under one
  or more contributor license agreements.  See the NOTICE file
  distributed with this work for additional information
  regarding copyright ownership.  The ASF licenses this file
  to you under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  KIND, either express or implied.  See the License for the
  specific language governing permissions and limitations
  under the License.

=end

class Fluent::LogglyOutputBuffered < Fluent::BufferedOutput
  Fluent::Plugin.register_output('loggly_buffered', self)
  config_param :loggly_url, :string, :default => nil
  config_param :output_include_time, :bool, :default => true  # Recommended
  config_param :time_precision_digits, :integer, :default => 0

  unless method_defined?(:log)
    define_method("log") { $log }
  end

  def configure(conf)
    super
    log.debug "Loggly url #{@loggly_url}"
  end

  def start
    super
    require 'net/http/persistent'
    @uri = URI @loggly_url
    @http = Net::HTTP::Persistent.new 'fluentd-plugin-loggly', :ENV
    @http.headers['Content-Type'] = 'text'
  end

  def shutdown
    super
  end

  def format(tag, time, record)
    if time.is_a?(Integer)
      [tag, time, record].to_msgpack
    else
      Fluent::Engine.msgpack_factory.packer.write([tag, time, record]).to_s
    end
  end

  def write(chunk)
    records = []
    chunk.msgpack_each {|tag,time,record|
      record['timestamp'] ||= Time.at(time).iso8601(@time_precision_digits) if @output_include_time
      records.push(Yajl::Encoder.encode(record))
    }
    log.debug "#{records.length} records sent"
    post = Net::HTTP::Post.new @uri.path
    post.body = records.join("\n")
    begin
      response = @http.request @uri, post
      log.debug "HTTP Response code #{response.code}"
      log.error response.body if response.code != "200"
    rescue
      log.error "Error connecting to loggly verify the url #{@loggly_url}"
    end
  end
end
