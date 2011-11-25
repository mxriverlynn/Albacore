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
			if File.exists? %q{C:\Program Files\Microsoft\ILMerge\ilmerge.exe}
				%q{C:\Program Files\Microsoft\ILMerge\ilmerge.exe}
			elsif File.exists? %q{C:\Program Files (x86)\Microsoft\ILMerge\ilmerge.exe}
				%q{C:\Program Files (x86)\Microsoft\ILMerge\ilmerge.exe}
			end
		end

	end

	class ConfigData
		
		attr_accessor :ilmerge_path

	end

end

