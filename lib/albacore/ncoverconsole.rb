require File.join(File.dirname(__FILE__), 'support', 'logging')

class NCoverConsole
	include LogBase
	
	attr_accessor :path_to_exe, :output, :testrunner, :working_directory, :cover_assemblies, :ignore_assemblies
	
	def initialize
		@output = {}
		@testrunner_args = []
		@cover_assemblies = []
		@ignore_assemblies = []
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
		command << @testrunner.get_command_line
		
		commandline = command.join(" ")

		@logger.info "Executing Code Coverage Analysis."
		@logger.debug "NCover Command Line: " + commandline

		output = system commandline
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
end