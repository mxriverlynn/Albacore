require 'rake/tasklib'

module Albacore
	def self.ncoverreport(name=:ncoverreport, *args, &block)
		NCoverReportTask.new(name, *args, &block)
	end
	
	class NCoverReportTask < Albacore::AlbacoreTask
		def execute(task_args)
			@ncoverreport = NCoverReport.new
			@block.call(@ncoverreport, *task_args) unless @block.nil?
			@ncoverreport.run
			fail if @ncoverreport.failed
		end		
	end
end
