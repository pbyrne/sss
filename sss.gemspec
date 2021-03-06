# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sss/version"

Gem::Specification.new do |s|
  s.name        = "simple-scm"
  s.version     = SSS::VERSION
  s.authors     = ["Patrick Byrne"]
  s.email       = ["patrick.byrne@tstmedia.com"]
  s.homepage    = "https://github.com/pbyrne/sss/"
  s.summary     = %q{Quickly perform SCM (git/hg/svn) commands across your projects.}
  s.description = %q{Provides the `sss` command to perform SCM (git/hg/svn) commands in all projects in a directory.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'aruba'
  # TODO discover how to load these two gems on my mac only, not on travis CI
  # s.add_development_dependency 'rb-fsevent'
  # s.add_development_dependency 'growl_notify'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-cucumber'
  s.add_development_dependency 'guard-rspec'

  # s.add_runtime_dependency "rest-client"
end
