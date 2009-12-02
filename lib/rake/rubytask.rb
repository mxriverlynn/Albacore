require 'rake/tasklib'

module Albacore
	class RubyTask < Rake::TaskLib
		attr_accessor :name

		def initialize(name=:ruby, &block)
			@name = name
			@block = block
			define
		end

		def define
			task name do
		  	   @block.call
			end
		end
	end
end