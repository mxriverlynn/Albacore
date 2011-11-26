require 'albacore/albacoretask'

class IlMerge 
	TaskName = :ilmerge
	include Albacore::Task
	include Albacore::RunCommand

	
end

module Albacore

	class IlMergeResolver

		def initialize(ilmerge_path=nil)
			@ilmerge_path ||= Albacore.configuration.ilmerge_path
		end

		def resolve
			m = ['', ' (x86)'].map{|x| "C:\\Program Files#{x}\\Microsoft\\ILMerge\\ilmerge.exe" }
			m.keep_if{|x| File.exists? x}
			m.first
		end

	end

	class ConfigData
		
		attr_accessor :ilmerge_path

	end

end

