require 'rake/tasklib'

module Albacore
	class Rename < Rake::TaskLib
		attr_accessor :name
		attr_accessor :actual_name, :target_name
		
		def initialize(name=:rename)
			@name = name
			yield self if block_given?
			define
		end
		
		def define
			task name do
				File.rename(@actual_name, @target_name)
			end
		end
	end
end
