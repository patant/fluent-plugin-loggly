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

class LogglyOutput < Fluent::Output
  Fluent::Plugin.register_output('loggly', self)
  config_param :loggly_url, :string, :default => nil

  def configure(conf)
    super
    $log.debug "Loggly url #{@loggly_url}"
  end

  def start
    super
    require "net/https"
    require "uri"
    require "json"
    uri = URI.parse @loggly_url
    @https = Net::HTTP.new(uri.host, uri.port)
    @https.use_ssl = true
    @request = Net::HTTP::Post.new(uri.request_uri, initheader={'Content-Type' => 'application/json'})
  end

  def shutdown
    super
  end

  def emit(tag, es, chain)
    chain.next
    es.each {|time,record|
      record_json = record.to_json
      $log.debug "Record sent #{record_json}"
      @request.body = record_json
      begin
        response = @https.request(@request)
        $log.debug "HTTP Response code #{response.code}"
        $log.error response.message if response.code != "200"
      rescue
        $log.error "Error connecting to loggly verify the url #{@loggly_url}"
      end
    }
  end
end
