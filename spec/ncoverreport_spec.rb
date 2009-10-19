require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'ncoverreport'
require 'ncoverreporttestdata'

describe NCoverReport, "when running a full coverage report with a specified output folder" do
	
	before :all do
		ncover = NCoverReport.new
		ncover.path_to_command = NCoverReportTestData.path_to_command
		
		
	end
	
	it "should tell ncover.reporting to produce the full coverage report" 
	
	it "should tell ncover.reporting where to put the report"
	
	it "should produce the report"
	
end
