require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'ncoverconsole'
require 'nunittestrunner'

@@ncoverpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'NCover-v3.2', 'NCover.Console.exe')
@@nunitpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'NUnit-v2.5', 'nunit-console.exe')
@@xml_coverage_output = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'test-coverage.xml')
@@html_coverage_output = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'html', 'test-coverage.html')
@@working_directory = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage')
@@test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'Assemblies', 'TestSolution.Tests.dll')

describe NCoverConsole, "when producing an xml coverage report with nunit" do
	before :all do
		File.delete(@@xml_coverage_output) if File.exist?(@@xml_coverage_output)
		
		ncc = NCoverConsole.new()
		
		ncc.extend(SystemPatch)
		ncc.log_level = :verbose
		ncc.path_to_exe = @@ncoverpath
		ncc.output = {:xml => @@xml_coverage_output}
		ncc.working_directory = @@working_directory
		
		nunit = NUnitTestRunner.new(@@nunitpath)
		nunit.assemblies << @@test_assembly
		nunit.options << '/noshadow'
		
		ncc.testrunner = nunit
		ncc.run
	end
	
	it "should execute ncover.console from the specified path" do
		$system_command.should include(@@ncoverpath)
	end
	
	it "should execute with the specified working directory" do
		$system_command.should include(@@working_directory)
	end
	
	it "should execute the test runner from the specified path" do
		$system_command.should include(@@nunitpath)
	end
	
	it "should pass the specified arguments to the test runner" do
		$system_command.should include("TestSolution.Tests.dll /noshadow")
	end
		
	it "should write the coverage data to the specified file" do
		File.exist?(@@xml_coverage_output).should == true
	end
end

describe NCoverConsole, "when specifying an html report and an xml coverage report with nunit" do
	before :all do
		File.delete(@@xml_coverage_output) if File.exist?(@@xml_coverage_output)
		File.delete(@@html_coverage_output) if File.exist?(@@html_coverage_output)
		
		ncc = NCoverConsole.new()
		
		ncc.extend(SystemPatch)
		ncc.log_level = :verbose
		ncc.path_to_exe = @@ncoverpath
		ncc.output = {:xml => @@xml_coverage_output, :html => @@html_coverage_output}
		ncc.working_directory = @@working_directory
		
		nunit = NUnitTestRunner.new(@@nunitpath)
		nunit.assemblies << @@test_assembly
		nunit.options << '/noshadow'
		
		ncc.testrunner = nunit
		ncc.run
	end

	
	it "should produce the xml report" do
		File.exist?(@@xml_coverage_output).should == true
	end
	
	it "should produce the html report" do
		File.exist?(@@html_coverage_output).should == true
	end
end

describe NCoverConsole, "when specifying aseemblies to cover" do
	before :all do
		File.delete(@@xml_coverage_output) if File.exist?(@@xml_coverage_output)
		
		ncc = NCoverConsole.new()
		
		ncc.extend(SystemPatch)
		ncc.log_level = :verbose
		ncc.path_to_exe = @@ncoverpath
		ncc.output = {:xml => @@xml_coverage_output}
		ncc.working_directory = @@working_directory
		ncc.cover_assemblies << "TestSolution"
		
		nunit = NUnitTestRunner.new(@@nunitpath)
		nunit.assemblies << @@test_assembly
		nunit.options << '/noshadow'
		
		ncc.testrunner = nunit
		ncc.run
	end

	it "should provide coverage for the specified assemblies" do
		$system_command.should include("//assemblies TestSolution")
	end
end

describe NCoverConsole, "when specifying aseemblies to ignore" do
	before :all do
		File.delete(@@xml_coverage_output) if File.exist?(@@xml_coverage_output)
		
		ncc = NCoverConsole.new()
		
		ncc.extend(SystemPatch)
		ncc.log_level = :verbose
		ncc.path_to_exe = @@ncoverpath
		ncc.output = {:xml => @@xml_coverage_output}
		ncc.working_directory = @@working_directory
		ncc.ignore_assemblies << "TestSolution.*"
		
		nunit = NUnitTestRunner.new(@@nunitpath)
		nunit.assemblies << @@test_assembly
		nunit.options << '/noshadow'
		
		ncc.testrunner = nunit
		ncc.run
	end

	it "should provide coverage for the specified assemblies" do
		$system_command.should include("//exclude-assemblies TestSolution.*")
	end
end
