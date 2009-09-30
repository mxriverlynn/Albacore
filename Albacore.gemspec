Gem::Specification.new do |s| 
	version = "0.0.2"

	s.version = version
	s.name = "Albacore"
	s.author = "Derick Bailey"
	s.email = "derickbailey@gmail.com"
	s.homepage = "http://github.com/derickbailey/Albacore"
	s.platform = Gem::Platform::RUBY
	s.summary = "A Suite of Rake Build Tasks For .Net Solutions"
	s.require_path = "lib"
	s.has_rdoc = false	
	
	#include all files
	s.files = Dir['**/*']

	#except for the ones named with these
	s.files.reject! { |fn| fn.include? '.git' }
	s.files.reject! { |fn| fn.include? '.cache' }
	s.files.reject! { |fn| fn.include? '/obj/' }
	s.files.reject! { |fn| fn.include? '/bin/' }
	s.files.reject! { |fn| fn.include? '_ReSharper' }
	s.files.reject! { |fn| fn.include? '.csproj.user' }
	s.files.reject! { |fn| fn.include? '.resharper.user' }
	s.files.reject! { |fn| fn.include? '.resharper' }
	s.files.reject! { |fn| fn.include? '.suo' }
	s.files.reject! { |fn| fn.include? '~$' }
	s.files.reject! { |fn| fn.include? '.tmp' }
	s.files.reject! { |fn| fn.include? '.eprj' }
	s.files.reject! { |fn| fn.include? "Albacore-#{version}.gem" }
end
