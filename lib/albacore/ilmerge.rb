require 'albacore/albacoretask'

class IlMerge 
	TaskName = :ilmerge
	include Albacore::Task
	include Albacore::RunCommand

	attr_accessor :output

	def initialize(resolver = nil)
		@resolver = resolver || Albacore::IlMergeResolver.new
		super()
	end

	def assemblies(*assys)
		raise ArgumentError, "expected at least 2 assemblies to merge" if assys.length < 2
		@assemblies = assys
	end

	def build_parameters
		params = Array.new @parameters
		params << "/out:#{output}"
		raise ArgumentError, "you are required to call assemblies" if @assemblies == nil
		params += @assemblies
		params
	end

	def run_command
		super(command_path, build_parameters)
	end
	
end

module Albacore

	class IlMergeResolver

		def initialize(ilmerge_path=nil)
			@ilmerge_path = ilmerge_path || Albacore.configuration.ilmerge_path
		end

		def path=(path)
			@ilmerge_path = path
		end

		def resolve
			if @ilmerge_path != nil
				@ilmerge_path
			else
				m = ['', ' (x86)'].map{|x| "C:\\Program Files#{x}\\Microsoft\\ILMerge\\ilmerge.exe" }
				m.keep_if{|x| File.exists? x}
				m.first
			end
		end

	end

	class ConfigData
		
		attr_accessor :ilmerge_path

	end

end

