require 'rake/tasklib'

module Albacore	
	class ExpandTemplatesTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:expandtemplates, &block)
			@name = name
			@exp = ExpandTemplates.new
			@block = block
			define
		end
		
		def define
			task @name do
				@block.call(@exp) unless @block.nil?
				@exp.expand
			end
		end	
	end
end