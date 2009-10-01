require File.join(File.dirname(__FILE__), 'support', 'logging')

class NCoverConsole
	include LogBase
	
	attr_accessor :path_to_exe, :output, :testrunner, :working_directory, :cover_assemblies, :ignore_assemblies, :coverage
	
	def initialize
		@output = {}
		@testrunner_args = []
		@cover_assemblies = []
		@ignore_assemblies = []
		@coverage = []
		super()
	end
	
	def working_directory=(working_dir)
		@working_directory = "//working-directory " + working_dir
	end
	
	def run
		command = []
		command << @path_to_exe
		command << build_output_options(@output) unless @output.nil?
		command << @working_directory unless @working_directory.nil?
		command << build_assembly_list("assemblies", @cover_assemblies) unless @cover_assemblies.empty?
		command << build_assembly_list("exclude-assemblies", @ignore_assemblies) unless @ignore_assemblies.empty?
		command << build_coverage_list(@coverage) unless @coverage.empty?
		command << @testrunner.get_command_line
		
		commandline = command.join(" ")

		@logger.info "Executing Code Coverage Analysis."
		@logger.debug "NCover Command Line: " + commandline

		result = system commandline
		
		check_for_success result
	end
	
	def check_for_success(success)
		return if success
		msg = 'Code Coverage Analysis Failed. See Build Log For Detail.'
		@logger.info msg
		raise msg
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