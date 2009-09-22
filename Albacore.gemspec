# -*- encoding: utf-8 -*-
require 'rake'

Gem::Specification.new do |s| 
	s.name = "Albacore"
	s.version = "0.0.3"
	
	s.author = "Derick Bailey"
	s.email = "derickbailey@gmail.com"
	s.homepage = "http://github.com/derickbailey/Albacore"
	s.platform = Gem::Platform::RUBY
	s.summary = "A Suite of Rake Build Tasks For .Net Solutions"
	s.files = FileList["rakefile.rb", "EULA.txt", "{lib}/**/*"].to_a
	s.require_path = "lib"
	# s.autorequire = "name"
	s.test_files = FileList["{spec}/**/*test.rb"].to_a
	s.has_rdoc = false
	# s.extra_rdoc_files = ["README"]
	# s.add_dependency("dependency", ">= 0.x.x")
	
end
