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
		end

	end

	class ConfigData
		
		attr_accessor :ilmerge_path

	end

end

