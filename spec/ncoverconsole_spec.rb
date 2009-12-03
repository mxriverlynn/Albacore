require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/ncoverconsole'
require 'albacore/nunittestrunner'
require 'albacore/mspectestrunner'

@@ncoverpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'NCover-v3.3', 'NCover.Console.exe')
@@nunitpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'NUnit-v2.5', 'nunit-console-x86.exe')
@@xml_coverage_output = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'nunit', 'test-coverage.xml')
@@html_coverage_output = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'nunit', 'html', 'test-coverage.html')
@@working_directory = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'nunit')
@@test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'nunit', 'assemblies', 'TestSolution.Tests.dll')
@@failing_test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'nunit', 'failing_assemblies', 'TestSolution.FailingTests.dll')

@@mspecpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'Machine.Specification-v0.2', 'Machine.Specifications.ConsoleRunner.exe')
@@mspec_html_output = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'mspec', 'html')
@@mspec_test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'mspec', 'assemblies', 'TestSolution.MSpecTests.dll')

describe NCoverConsole, "when specifying aseemblies to cover" do
	before :all do
		File.delete(@@xml_coverage_output) if File.exist?(@@xml_coverage_output)
		
		@ncc = NCoverConsole.new()
		
		@ncc.extend(SystemPatch)
		@ncc.log_level = :verbose
		@ncc.path_to_command = @@ncoverpath
		@ncc.output = {:xml => @@xml_coverage_output}
		@ncc.working_directory = @@working_directory
		@ncc.cover_assemblies << "TestSolution"
		
		nunit = NUnitTestRunner.new(@@nunitpath)
		nunit.assemblies << @@test_assembly
		nunit.options << '/noshadow'
		
		@ncc.testrunner = nunit
		@ncc.run
	end

	it "should provide coverage for the specified assemblies" do
		@ncc.system_command.should include("//assemblies \"TestSolution\"")
	end
end

describe NCoverConsole, "when specifying assemblies to ignore" do
	before :all do
		File.delete(@@xml_coverage_output) if File.exist?(@@xml_coverage_output)
		
		@ncc = NCoverConsole.new()
		
		@ncc.extend(SystemPatch)
		@ncc.log_level = :verbose
		@ncc.path_to_command = @@ncoverpath
		@ncc.output = {:xml => @@xml_coverage_output}
		@ncc.working_directory = @@working_directory
		@ncc.ignore_assemblies << "TestSolution.*"
		
		nunit = NUnitTestRunner.new(@@nunitpath)
		nunit.assemblies << @@test_assembly
		nunit.options << '/noshadow'
		
		@ncc.testrunner = nunit
		@ncc.run
	end

	it "should provide coverage for the specified assemblies" do
		@ncc.system_command.should include("//exclude-assemblies \"TestSolution.*\"")
	end
end

describe NCoverConsole, "when specifying the types of coverage to analyze" do
	before :all do
		File.delete(@@xml_coverage_output) if File.exist?(@@xml_coverage_output)
		
		@ncc = NCoverConsole.new()
		
		@ncc.extend(SystemPatch)
		@ncc.log_level = :verbose
		@ncc.path_to_command = @@ncoverpath
		@ncc.output = {:xml => @@xml_coverage_output}
		@ncc.working_directory = @@working_directory
		@ncc.coverage = [:Symbol, :Branch, :MethodVisits, :CyclomaticComplexity]
		
		nunit = NUnitTestRunner.new(@@nunitpath)
		nunit.assemblies << @@test_assembly
		nunit.options << '/noshadow'
		
		@ncc.testrunner = nunit
		@ncc.run
	end
		
	it "should only run coverage for those metrics" do
		@ncc.system_command.should include("//coverage-type \"Symbol, Branch, MethodVisits, CyclomaticComplexity\"")
	end
end

describe NCoverConsole, "when analyzing a test suite with failing tests" do
	before :all do
		File.delete(@@xml_coverage_output) if File.exist?(@@xml_coverage_output)
		
		ncc = NCoverConsole.new()
		strio = StringIO.new
		ncc.log_device = strio
		
		ncc.extend(SystemPatch)
		ncc.log_level = :verbose
		ncc.path_to_command = @@ncoverpath
		ncc.output = {:xml => @@xml_coverage_output}
		ncc.working_directory = @@working_directory
		
		nunit = NUnitTestRunner.new(@@nunitpath)
		nunit.assemblies << @@failing_test_assembly
		nunit.options << '/noshadow'
		
		ncc.testrunner = nunit
		
		ncc.run
		@failed = ncc.failed
		@log_data = strio.string
	end
	
	it "should return a failure code" do
		@failed.should == true
	end
	
	it "should log a failure message" do
		@log_data.should include("Code Coverage Analysis Failed. See Build Log For Detail.")
	end
end

describe NCoverConsole, "when running without a testrunner" do
	before :all do
		ncc = NCoverConsole.new()
		strio = StringIO.new
		ncc.log_device = strio
		
		@result = ncc.run
		@log_data = strio.string
	end

	it "should log a message saying the test runner is required" do
		@log_data.should include("testrunner cannot be nil.")
	end
	
	it "should return a failure code" do
		@result.should == false
	end
end

describe NCoverConsole, "when producing an xml coverage report with nunit" do
	before :all do
		File.delete(@@xml_coverage_output) if File.exist?(@@xml_coverage_output)
		
		@ncc = NCoverConsole.new()
		
		@ncc.extend(SystemPatch)
		@ncc.log_level = :verbose
		@ncc.path_to_command = @@ncoverpath
		@ncc.output = {:xml => @@xml_coverage_output}
		@ncc.working_directory = @@working_directory
		
		nunit = NUnitTestRunner.new(@@nunitpath)
		nunit.assemblies << @@test_assembly
		nunit.options << '/noshadow'
		
		@ncc.testrunner = nunit
		@ncc.run
	end
	
	it "should execute ncover.console from the specified path" do
		@ncc.system_command.should include(@@ncoverpath)
	end
	
	it "should execute with the specified working directory" do
		@ncc.system_command.should include(@@working_directory)
	end
	
	it "should execute the test runner from the specified path" do
		@ncc.system_command.should include(@@nunitpath)
	end
	
	it "should pass the specified arguments to the test runner" do
		@ncc.system_command.should include("TestSolution.Tests.dll /noshadow")
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
		ncc.path_to_command = @@ncoverpath
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

describe NCoverConsole, "when producing a report with machine.specifications" do
	before :all do
		@ncc = NCoverConsole.new()
		
		@ncc.extend(SystemPatch)
		@ncc.log_level = :verbose
		@ncc.path_to_command = @@ncoverpath
		@ncc.output = {:xml => @@xml_coverage_output}
		@ncc.working_directory = @@working_directory
		
		mspec = MSpecTestRunner.new(@@mspecpath)
		mspec.assemblies << @@mspec_test_assembly
		mspec.html_output = @@mspec_html_output
		
		@ncc.testrunner = mspec
		@ncc.run
	end

	it "should not fail" do
		@ncc.failed.should be_false
	end

	it "should produce the html report" do
		File.exist?(@@mspec_html_output.to_s).should be_true
	end

end