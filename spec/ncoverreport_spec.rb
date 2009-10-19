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
		
		fullcoveragereport = NCover::Reports::FullCoverageReport.new()
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

describe NCoverReport, "when running a summary report with a specified output folder" do
	before :all do
		NCoverReportTestData.clean_output_folder
		
		ncover = NCoverReport.new
		ncover.extend(SystemPatch)
		ncover.log_level = :verbose
		
		ncover.path_to_command = NCoverReportTestData.path_to_command
		ncover.coverage_files << NCoverReportTestData.coverage_file
		
		summaryreport = NCover::Reports::SummaryReport.new()
		summaryreport.output_path = NCoverReportTestData.summary_output_file
		ncover.reports << summaryreport
		
		ncover.run
	end

	it "should execute ncover.reporting" do
		$system_command.should include(NCoverReportTestData.path_to_command)
	end
	
	it "should tell ncover.reporting to produce a summary html report in the specified folder" do
		$system_command.should include("//or Summary:Html:\"#{NCoverReportTestData.summary_output_file}\"")
	end
	
	it "should produce the report" do
		File.exist?(NCoverReportTestData.summary_output_file).should be_true
	end		
end

describe NCoverReport, "when running multiple ncover reports - a summary and a full coverage report" do
	before :all do
		NCoverReportTestData.clean_output_folder
		
		ncover = NCoverReport.new
		ncover.extend(SystemPatch)
		ncover.log_level = :verbose
		
		ncover.path_to_command = NCoverReportTestData.path_to_command
		ncover.coverage_files << NCoverReportTestData.coverage_file
		
		summaryreport = NCover::Reports::SummaryReport.new()
		summaryreport.output_path = NCoverReportTestData.summary_output_file
		ncover.reports << summaryreport
		
		fullcoveragereport = NCover::Reports::FullCoverageReport.new()
		@fullcoverage_output_folder = File.join(NCoverReportTestData.output_folder, "fullcoverage")
		fullcoveragereport.output_path = @fullcoverage_output_folder
		ncover.reports << fullcoveragereport

		ncover.run
	end

	it "should tell ncover.reporting to produce a full coverage html report in the specified folder" do
		$system_command.should include("//or FullCoverageReport:Html:\"#{@fullcoverage_output_folder}\"")
	end
	
	it "should tell ncover.reporting to produce a summary html report in the specified folder" do
		$system_command.should include("//or Summary:Html:\"#{NCoverReportTestData.summary_output_file}\"")
	end
end

describe NCoverReport, "when running a report with a specified minimum symbol coverage lower than actual coverage" do
	before :all do
		NCoverReportTestData.clean_output_folder
		
		@ncover = NCoverReport.new
		@ncover.extend(SystemPatch)
		@ncover.log_level = :verbose
		
		@ncover.path_to_command = NCoverReportTestData.path_to_command
		@ncover.coverage_files << NCoverReportTestData.coverage_file
		
		fullcoveragereport = NCover::Reports::FullCoverageReport.new
		fullcoveragereport.output_path = NCoverReportTestData.output_folder
		@ncover.reports << fullcoveragereport
		
		symbolcoverage = NCover::Reports::SymbolCoverage.new
		symbolcoverage.minimum = 10
		symbolcoverage.coverage_level = :View
		@ncover.minimum_coverage << symbolcoverage
		
		@ncover.run
	end

	it "should tell ncover.reporting to check for the specified minimum coverage" do
		$system_command.should include("//mc SymbolCoverage:10")
	end
	
	it "should not fail the execution" do
		@ncover.failed.should be_false
	end
	
	it "should produce the report" do
		File.exist?(File.join(NCoverReportTestData.output_folder, "fullcoveragereport.html")).should be_true
	end	
end

describe NCoverReport, "when running a report with a specified minimum symbol coverage higher than actual coverage" do
	before :all do
		NCoverReportTestData.clean_output_folder
		
		@ncover = NCoverReport.new
		@ncover.extend(SystemPatch)
		@ncover.log_level = :verbose
		
		@ncover.path_to_command = NCoverReportTestData.path_to_command
		@ncover.coverage_files << NCoverReportTestData.coverage_file
		
		fullcoveragereport = NCover::Reports::FullCoverageReport.new
		fullcoveragereport.output_path = NCoverReportTestData.output_folder
		@ncover.reports << fullcoveragereport
		
		symbolcoverage = NCover::Reports::SymbolCoverage.new
		symbolcoverage.minimum = 100
		symbolcoverage.coverage_level = :View
		@ncover.minimum_coverage << symbolcoverage
		
		@ncover.run
	end

	it "should tell ncover.reporting to check for the specified minimum coverage" do
		$system_command.should include("//mc SymbolCoverage:10")
	end
	
	it "should fail the execution" do
		@ncover.failed.should be_true
	end
	
	it "should produce the report" do
		File.exist?(File.join(NCoverReportTestData.output_folder, "fullcoveragereport.html")).should be_true
	end	
end
