require 'rubygems'
require 'rubygems/gem_runner'
require 'rubygems/exceptions'

#http://gist.github.com/236148
required_version = Gem::Requirement.new "> 1.8.3"

unless required_version.satisfied_by? Gem.ruby_version then
  abort "Expected Ruby Version #{required_version}, was #{Gem.ruby_version}"
end

def install(lib)
  begin
    Gem::GemRunner.new.run ['install', lib]
  rescue Gem::SystemExitException => e
  end
end

def add_source(url)
  begin
    Gem::GemRunner.new.run ['sources', '-a', url]
  rescue Gem::SystemExitException => e
  end
end

puts "Installing required dependencies"
add_source 'http://gemcutter.org'
install 'net-sftp'
install 'rubyzip'
install 'jeweler'
install 'derickbailey-notamock'