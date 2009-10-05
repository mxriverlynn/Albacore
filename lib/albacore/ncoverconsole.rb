require File.join(File.dirname(__FILE__), 'support', 'albacorebase')

class NCoverConsole
	include CommandBase
	
	attr_accessor :output, :testrunner, :working_directory, :cover_assemblies
	attr_accessor :ignore_assemblies, :coverage
	
	def initialize
		super()
		@output = {}
		@testrunner_args = []
		@cover_assemblies = []
		@ignore_assemblies = []
		@coverage = []
	end
	
	def working_directory=(working_dir)
		@working_directory = "//working-directory " + working_dir
	end
	
	def run
		check_testrunner
		return false if @failed
		
		command_parameters = []
		command_parameters << build_output_options(@output) unless @output.nil?
		command_parameters << @working_directory unless @working_directory.nil?
		command_parameters << build_assembly_list("assemblies", @cover_assemblies) unless @cover_assemblies.empty?
		command_parameters << build_assembly_list("exclude-assemblies", @ignore_assemblies) unless @ignore_assemblies.empty?
		command_parameters << build_coverage_list(@coverage) unless @coverage.empty?
		command_parameters << @testrunner.get_command_line
		
		result = run_command "NCover.Console", command_parameters.join(" ")
		
		failure_msg = 'Code Coverage Analysis Failed. See Build Log For Detail.'
		fail_with_message failure_msg if !result
	end
	
	def check_testrunner
		return if (!@testrunner.nil?)
		msg = 'testrunner cannot be nil.'
		@logger.info msg
		fail
	end
	
	def build_output_options(output)
		options = []
		output.each do |key, value|
			options << "//#{key} #{value}"
		end
		options.join(" ")
	end
	
	def build_assembly_list(param_name, list)
		"//#{param_name} #{list.join(';')}"
	end
	
	def build_coverage_list(coverage)
		"//coverage-type \"#{coverage.join(', ')}\""
	end
end