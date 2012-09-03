# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require 'version'

Gem::Specification.new do |s|
  s.name        = 'albacore'
  s.version     = Albacore::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Henrik Feldt', 'Anthony Mastrean']
  s.email       = 'henrik@haf.se'
  s.homepage    = 'http://albacorebuild.net'
  s.summary     = 'Dolphin-safe and awesome Mono and .Net Rake-tasks'
  s.description = 'Easily build your .Net or Mono project using this collection of Rake tasks.'

  s.add_development_dependency 'nokogiri'
  s.add_development_dependency 'jekyll'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_dependency 'rubyzip'

  s.rubyforge_project = 'albacore'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ['lib']
end
