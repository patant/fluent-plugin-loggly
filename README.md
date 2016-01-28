Loggly plugin for [Fluentd](http://www.fluentd.org)
=============

[![Gem](https://img.shields.io/gem/dt/fluent-plugin-loggly.svg)](https://rubygems.org/gems/fluent-plugin-loggly)

With fluent-plugin-loggly you will be able to use [Loggly](http://loggly.com) as output the logs you collect with Fluentd.

## Getting Started
* Install [Fluentd](http://www.fluentd.org/download)
* `gem install fluent-plugin-loggly` or if you are using the agent `td-agent-gem install fluent-plugin-loggly`
* Make sure you have an account with Loggly.
* Configure Fluentd as below:
~~~~~
    <match your_match>
      type loggly
      loggly_url https://logs-01.loggly.com/inputs/xxx-xxxx-xxxx-xxxxx-xxxxxxxxxx
    </match>
~~~~~
or if you want to use buffered plugin:
~~~~~
    <match your_match>
      type loggly_buffered
      loggly_url https://logs-01.loggly.com/bulk/xxx-xxxx-xxxx-xxxxx-xxxxxxxxxx
      output_include_time true  # add 'timestamp' record into log. (default: true)
      buffer_type    file
      buffer_path    /path/to/buffer/file
      flush_interval 10s
    </match>
~~~~~
   
Note that buffered plugin uses bulk import to improve performance, so make sure to set Bulk endpoint to loggly_url.

The `xxx-xxxx...` is your Loggly access token.

## Parameters
**loggly_url** the url to your loggly input (string).
