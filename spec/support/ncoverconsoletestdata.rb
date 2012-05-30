class NCoverConsoleTestData
  attr_accessor :ncoverpath, :nunitpath, :xml_coverage_output, :html_coverage_output, :working_directory
  attr_accessor :test_assembly, :failing_test_assembly, :mspecpath, :mspec_html_output, :mspec_test_assembly
  attr_accessor :test_assembly_with_spaces
    
  def initialize
    @ncoverpath = File.join(File.dirname(__FILE__), '..', 'support', 'Tools', 'NCover-v3.3', 'NCover.Console.exe')
    @nunitpath = File.join(File.dirname(__FILE__), '..', 'support', 'Tools', 'NUnit-v2.5', 'nunit-console-x86.exe')
    @xml_coverage_output = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'support', 'CodeCoverage', 'nunit', 'test-coverage.xml')
    @html_coverage_output = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'support', 'CodeCoverage', 'nunit', 'html', 'test-coverage.html')
    @working_directory = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'support', 'CodeCoverage', 'nunit')
    @test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'support', 'CodeCoverage', 'nunit', 'assemblies', 'TestSolution.Tests.dll')
    @test_assembly_with_spaces = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'support', 'CodeCoverage', 'nunit', 'assemblies/with spaces/', 'TestSolution.Tests.dll')
    @failing_test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'support', 'CodeCoverage', 'nunit', 'failing_assemblies', 'TestSolution.FailingTests.dll')
  
    @mspecpath = File.join(File.dirname(__FILE__), '..', 'support', 'Tools', 'Machine.Specifications-0.5.3', 'tools', 'mspec-x86-clr4.exe')
    @mspec_html_output = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'support', 'CodeCoverage', 'mspec', 'html')
    @mspec_test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'support', 'CodeCoverage', 'mspec', 'assemblies', 'TestSolution.MSpecTests.dll')
  end
end