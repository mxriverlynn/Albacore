Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), 'ncoverreports/*.rb')).each {|f| require f }
require File.join(File.dirname(__FILE__), 'support', 'albacore_helper')

class NCoverReport
	include RunCommand
	include YAMLConfig
	
	attr_accessor :coverage_files, :reports, :minimum_coverage
	
	def initialize
		super()
		@coverage_files = []
		@reports = []
		@minimum_coverage = []
	end
	
	def run
		#check_testrunner
		#return false if @failed
		
		command_parameters = []
		command_parameters << build_coverage_files unless @coverage_files.empty?
		command_parameters << build_reports unless @reports.empty?
		command_parameters << build_minimum_coverage unless @minimum_coverage.empty?
		
		result = run_command "NCover.Reporting", command_parameters.join(" ")
		
		failure_msg = 'Code Coverage Reporting Failed. See Build Log For Detail.'
		fail_with_message failure_msg if !result
	end
	
	def build_coverage_files
		@coverage_files.map{|f| "\"#{f}\""}.join(" ")
	end
	
	def build_reports
		@reports.map{|r|
			report = "//or #{r.report_type}"
			report << ":#{r.report_format}" unless r.report_format.nil?
			report << ":\"#{r.output_path}\"" unless r.output_path.nil?
			report
		}.join(" ")
	end

	def build_minimum_coverage
		@minimum_coverage.map{|c|
			coverage = "//mc #{c.get_coverage_options}"
		}.join(" ")
	end
end