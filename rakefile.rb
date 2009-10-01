require 'spec/rake/spectask'
require 'lib/albacore'

task :default => ['specs:assemblyinfo', 'specs:msbuild', 'specs:run']

namespace :specs do
	@@specs_to_run=[]
	@spec_opts = '--colour --format specdoc'

	desc "Run setup functional specs for Albacore"
	task :all => [
		'specs:assemblyinfo', 
		'specs:msbuild', 
		'specs:sqlcmd', 
		'specs:ncover', 
		'specs:run'
	]
	
	desc "Setup the assembly info functional specs"
	task :assemblyinfo do
		@@specs_to_run << 'lib/spec/assemblyinfo_spec.rb'
		@@specs_to_run << 'lib/spec/assemblyinfotask_spec.rb'
	end
	
	desc "Setup the msbuild functional specs"
	task :msbuild do
		@@specs_to_run << 'lib/spec/msbuild_spec.rb'
		@@specs_to_run << 'lib/spec/msbuildtask_spec.rb'
	end

	desc "Setup SQLServer SQLCmd functional specs" 
	task :sqlcmd do
		@@specs_to_run << 'lib/spec/sqlcmd_spec.rb'
		@@specs_to_run << 'lib/spec/sqlcmdtask_spec.rb'
	end
	
	desc "Setup NCover functional specs"
	task :ncover do
		@@specs_to_run << 'lib/spec/ncoverconsole_spec.rb'
		@@specs_to_run << 'lib/spec/ncoverconsoletask_spec.rb'
	end
	
	Spec::Rake::SpecTask.new :run do |t|
		t.spec_opts << @spec_opts
		t.spec_files = @@specs_to_run
	end
end

namespace :albacore do	
	desc "Run a complete Albacore build sample"
	task :sample => ['albacore:assemblyinfo', 'albacore:msbuild', 'albacore:ncoverconsole']
	
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
	
	desc "Run a sample NCover Console code coverage"
	Rake::NCoverConsoleTask.new(:ncoverconsole) do |ncc|
		@xml_coverage = "lib/spec/support/CodeCoverage/test-coverage.xml"
		File.delete(@xml_coverage) if File.exist?(@xml_coverage)
		
		ncc.log_level = :verbose
		ncc.path_to_exe = "lib/spec/support/Tools/NCover-v3.2/NCover.Console.exe"
		ncc.coverage :xml, @xml_coverage
		ncc.working_directory = "lib/spec/support/CodeCoverage"
		
		nunit = NUnitTestRunner.new("lib/spec/support/Tools/NUnit-v2.5/nunit-console.exe")
		nunit.log_level = :verbose
		nunit.assemblies << "lib/spec/support/CodeCoverage/assemblies/TestSolution.Tests.dll"
		nunit.options << '/noshadow'
		
		ncc.testrunner = nunit
	end
end
