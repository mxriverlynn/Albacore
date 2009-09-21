require 'spec/rake/spectask'
require 'rake/gempackagetask'

task :default => 'albacore:specs'

namespace :albacore do
  desc "Run functional specs for Albacore"
  Spec::Rake::SpecTask.new :specs do |t|
	t.spec_opts << '--colour'
	t.spec_opts << '--format specdoc'
    t.spec_files = FileList['lib/spec/**/*_spec.rb']
  end
end


gem_specification = Gem::Specification.new do |s| 
  s.name = "Albacore"
  s.version = "0.0.1"
  s.author = "Derick Bailey"
  s.email = "derickbailey@gmail.com"
  s.homepage = "http://github.com/derickbailey/Albacore"
  s.platform = Gem::Platform::RUBY
  s.summary = "A Suite of Rake Build Tasks For .Net Solutions"
  s.files = FileList["{lib}/**/*"].to_a
  s.require_path = "lib"
  # s.autorequire = "name"
  s.test_files = FileList["{spec}/**/*test.rb"].to_a
  s.has_rdoc = false
  # s.extra_rdoc_files = ["README"]
  # s.add_dependency("dependency", ">= 0.x.x")
end
 
Rake::GemPackageTask.new(gem_specification) do |pkg| 
  pkg.need_tar = true 
end 
