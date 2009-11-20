require 'rake/tasklib'

module Albacore
	class NCoverReportTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:ncoverreport, &block)
			@name = name
			@ncoverreport = NCoverReport.new
			@block = block
			define
		end
		
		def define
			task name do
				@block.call(@ncoverreport) unless @block.nil?
				@ncoverreport.run
				fail if @ncoverreport.failed
			end
		end		
	end
end
