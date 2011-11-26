require 'albacore/albacoretask'

class IlMerge 
	TaskName = :ilmerge
	include Albacore::Task
	include Albacore::RunCommand

	def assemblies(assys = [])
		raise ArgumentError
	end
	
end

module Albacore

	class IlMergeResolver

		def initialize(ilmerge_path=nil)
			@ilmerge_path = ilmerge_path || Albacore.configuration.ilmerge_path
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

