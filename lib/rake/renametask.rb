require 'rake/tasklib'

module Albacore
	class RenameTask < Rake::TaskLib
		attr_accessor :name
		attr_accessor :actual_name, :target_name
		
		def initialize(name=:rename, &block)
			@name = name
			@block = block
			define
		end
		
		def define
			task name do
				@block.call(self) unless @block.nil?
				if (@actual_name.nil? || @target_name.nil?)
					fail
				else
					File.rename(@actual_name, @target_name)
				end
			end
		end
	end
end
