Loggly plugin for [Fluentd](http://www.fluentd.org)
=============
With fluent-plugin-loggly you will be able to use [Loggly](http://loggly.com) as output the logs you collect with Fluentd.

# Getting Started
* Install [Fluentd](http://www.fluentd.org/download)
* gem install fluent-plugin-loggly
* Make sure you have an account with Loggly.
* Configure Fluentd as below:
~~~~~
    <match your_match>
      type loggly
      loggly_url https://logs-01.loggly.com/inputs/xxx-xxxx-xxxx-xxxxx-xxxxxxxxxx
    </match>
~~~~~
    The `xxx-xxxx...` is your Loggly access token.

## Parameters
**loggly_url** the url to your loggly input (string).

