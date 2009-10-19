require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'ncoverreport'
require 'ncoverreporttestdata'

describe NCoverReport, "when running a full coverage report with a specified output folder" do
	before :all do
		NCoverReportTestData.clean_output_folder
		
		ncover = NCoverReport.new
		ncover.extend(SystemPatch)
		ncover.log_level = :verbose
		
		ncover.path_to_command = NCoverReportTestData.path_to_command
		ncover.coverage_files << NCoverReportTestData.coverage_file
		
		fullcoveragereport = NCover::Reports::FullCoverage.new()
		fullcoveragereport.output_path = NCoverReportTestData.output_folder
		ncover.reports << fullcoveragereport
		
		ncover.run
	end

	it "should execute ncover.reporting" do
		$system_command.should include(NCoverReportTestData.path_to_command)
	end
	
	it "should tell ncover.reporting to produce a full coverage html report in the specified folder" do
		$system_command.should include("//or FullCoverageReport:Html:\"#{NCoverReportTestData.output_folder}\"")
	end
	
	it "should produce the report" do
		File.exist?(File.join(NCoverReportTestData.output_folder, "fullcoveragereport.html")).should be_true
	end
	
end
