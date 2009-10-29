require 'rake/tasklib'

module Albacore
	class RenameTask < Rake::TaskLib
		attr_accessor :name
		attr_accessor :actual_name, :target_name
		
		def initialize(name=:rename)
			@name = name
			yield self if block_given?
			define
		end
		
		def define
			task name do
				if (@actual_name.nil? || @target_name.nil?)
					fail
				else
					File.rename(@actual_name, @target_name)
				end
			end
		end
	end
end
