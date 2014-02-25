# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "fluent-plugin-loggly"
  s.version     = "0.0.4"
  s.authors     = ["Patrik Antonsson"]
  s.email       = ["patant@gmail.com"]
  s.homepage    = "https://github.com/patant/fluent-plugin-loggly"
  s.summary     = %q{Fluentd plugin for output to loggly}
  s.description = %q{Fluentd pluging (fluentd.org) for output to loggly (loggly.com)}

  s.rubyforge_project = "fluent-plugin-loggly"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.add_dependency('net-http-persistent', '>= 2.7')

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
