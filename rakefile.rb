require 'spec/rake/spectask'
require 'lib/albacore'

task :default => 'specs:core'

namespace :specs do
	desc "Run all functional specs for Albacore"
	task :all => ['specs:core', 'specs:sqlcmd']
	
	desc "Run the core functional specs"
	Spec::Rake::SpecTask.new :core do |t|
		t.spec_opts << '--colour'
		t.spec_opts << '--format specdoc'
		t.spec_files = FileList[
			'lib/spec/assemblyinfo_spec.rb',
			'lib/spec/assemblyinfotask_spec.rb',
			'lib/spec/msbuild_spec.rb',
			'lib/spec/msbuildtask_spec.rb'
		]
	end
	
	desc "Run SQLServer SQLCmd functional specs" 
	Spec::Rake::SpecTask.new :sqlcmd do |t|
		t.spec_opts << '--colour'
		t.spec_opts << '--format specdoc'
		t.spec_files = FileList[
			'lib/spec/sqlcmd_spec.rb',
			'lib/spec/sqlcmdtask_spec.rb'
		]
	end
	
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
		asm.company_name = "a test company"
		asm.product_name = "a product name goes here"
		asm.title = "my assembly title"
		asm.description = "this is the assembly description"
		asm.copyright = "copyright some year, by some legal entity"
		asm.custom_attributes :SomeAttribute => "some value goes here", :AnotherAttribute => "with some data"
		
		asm.output_file = "lib/spec/support/AssemblyInfo/AssemblyInfo.cs"
	end
end
