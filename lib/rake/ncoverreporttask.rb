require 'rake/tasklib'

module Albacore
	class NCoverReportTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:ncoverreport)
			@name = name
			@ncoverreport = NCoverReport.new
			yield @ncoverreport if block_given?
			define
		end
		
		def define
			task name do
				@ncoverreport.run
				fail if @ncoverreport.failed
			end
		end		
	end
end
