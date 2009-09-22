require 'spec/rake/spectask'
require 'lib/albacore'

task :default => :specs

desc "Run functional specs for the Albacore framework"
Spec::Rake::SpecTask.new :specs do |t|
	t.spec_opts << '--colour'
	t.spec_opts << '--format specdoc'
	t.spec_files = FileList['lib/spec/**/*_spec.rb']
end

namespace :albacore do
	
	desc "Run a complete Albacore build sample"
	task :sample => ['albacore:assemblyinfo', 'albacore:msbuild']
	
	desc "Run a sample build using the MSBuildTask"
	Rake::MSBuildTask.new(:msbuild) do |msb|
		msb.properties :configuration => :Debug
		msb.targets [:Clean, :Build]
		msb.solution = "lib/spec/support/TestSolution/TestSolution.sln"
	end
	
	desc "Run a sample assembly info generator"
	Rake::AssemblyInfoTask.new(:assemblyinfo) do |asm|
		asm.version = "0.1.2.3"
		asm.title = "my assembly title"
		asm.description = "this is the assembly description"
		asm.file = "lib/spec/support/AssemblyInfo/AssemblyInfo.cs"
		asm.custom_attributes :SomeAttribute => "some value goes here", :AnotherAttribute => "with some data"
	end
end
