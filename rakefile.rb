task :default => ['albacore:sample']

namespace :specs do
	require 'spec/rake/spectask'

	@spec_opts = '--colour --format specdoc'

	desc "Run setup functional specs for Albacore"
	Spec::Rake::SpecTask.new :all do |t|
		t.spec_files = 'lib/spec/**/*_spec.rb'
		t.spec_opts << @spec_opts
	end
	
	desc "Setup the assembly info functional specs"
	Spec::Rake::SpecTask.new :assemblyinfo do |t|
		t.spec_files = 'lib/spec/assemblyinfo*_spec.rb'
		t.spec_opts << @spec_opts
	end
	
	desc "Setup the msbuild functional specs"
	Spec::Rake::SpecTask.new :assemblyinfo do |t|
		t.spec_files = 'lib/spec/msbuild*_spec.rb'
		t.spec_opts << @spec_opts
	end

	desc "Setup SQLServer SQLCmd functional specs" 
	Spec::Rake::SpecTask.new :assemblyinfo do |t|
		t.spec_files = 'lib/spec/sqlcmd*_spec.rb'
		t.spec_opts << @spec_opts
	end
	
	desc "Setup NCover functional specs"
	Spec::Rake::SpecTask.new :assemblyinfo do |t|
		t.spec_files = 'lib/spec/ncoverconsole*_spec.rb'
		t.spec_opts << @spec_opts
	end	
end

namespace :albacore do	
	require 'lib/albacore'

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
		ncc.path_to_command = "lib/spec/support/Tools/NCover-v3.2/NCover.Console.exe"
		ncc.output = {:xml => @xml_coverage, :html => "lib/spec/support/CodeCoverage/html"}
		ncc.working_directory = "lib/spec/support/CodeCoverage"
		
		nunit = NUnitTestRunner.new("lib/spec/support/Tools/NUnit-v2.5/nunit-console.exe")
		nunit.log_level = :verbose
		nunit.assemblies << "assemblies/TestSolution.Tests.dll"
		nunit.options << '/noshadow'
		
		ncc.testrunner = nunit
	end
end

require 'jeweler'	
Jeweler::Tasks.new do |gs|
	gs.name = "Albacore"
	gs.summary = "A Suite of Rake Build Tasks For .Net Solutions"
	gs.description = "Easily build your .NET solutions with rake, using this suite of custom tasks."
	gs.email = "derickbailey@gmail.com"
	gs.homepage = "http://github.com/derickbailey/Albacore"
	gs.authors = "Derick Bailey"
	gs.has_rdoc = false	
	gs.files.exclude("Albacore.gemspec", ".gitignore")
end
