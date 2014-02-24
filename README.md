Loggly plugin for [Fluentd](http://fluentd.org)
=============
With fluent-plugin-loggly you will be able to use the service loggly.com as output for you fluentd logs.

# Getting Started
* Install fluentd http://fluentd.org
* gem install fluent-plugin-loggly
* Make sure you have an account at loggly.com.
* Create a input.
* Choose service type: HTTP
* JSON logging: true
* Get the url that could by used to do HTTPS POST (this will be used for configuration of the plugin).
  It should be something like https://logs.loggly.com/inputs/xxx-xxxx-xxxx-xxxxx-xxxxxxxxxx

## Parameters
**loggly_url** the url to your loggly input (string)  

Setup the loggly output:

~~~~~
    <match your_match>
      type loggly
      loggly_url https://logs.loggly.com/inputs/xxx-xxxx-xxxx-xxxxx-xxxxxxxxxx
    </match>
~~~~~

# TODO
?
