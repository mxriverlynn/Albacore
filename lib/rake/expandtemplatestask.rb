require 'rake/tasklib'

module Albacore	
	class ExpandTemplatesTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:expandtemplates)
			@name = name
			@exp = ExpandTemplates.new
			yield @exp if block_given?
			define
		end
		
		def define
			task @name do
				@exp.expand
			end
		end	
	end
end