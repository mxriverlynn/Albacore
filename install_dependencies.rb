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
  	matches = Gem.source_index.find_name(lib)
    if matches.empty?
    	puts "Installing #{lib}"
    	Gem::GemRunner.new.run ['install', lib]
    else
    	puts "Found #{lib} gem - skipping"
    end
  rescue Gem::SystemExitException => e
  end
end

def add_source(url)
  begin
  	if Gem.sources.include?(url)
  		puts "Found #{url} gem source = skipping"
  	else
  		puts "Adding #{url} gem source."
		Gem::GemRunner.new.run ['sources', '-a', url]
	end
  rescue Gem::SystemExitException => e
  end
end

puts "Installing required dependencies"
add_source 'http://gemcutter.org'
install 'rake'
install 'net-ssh'
install 'net-sftp'
install 'rubyzip'
install 'jeweler'
install 'rspec'
install 'derickbailey-notamock'
install 'jekyll'
