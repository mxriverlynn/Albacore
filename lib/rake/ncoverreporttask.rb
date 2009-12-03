require 'rake/tasklib'

def ncoverreporttask(name=:ncoverreport, *args, &block)
	Albacore::NCoverReportTask.new(name, *args, &block)
end
	
module Albacore
	class NCoverReportTask < Albacore::AlbacoreTask
		def execute(task_args)
			@ncoverreport = NCoverReport.new
			@block.call(@ncoverreport, *task_args) unless @block.nil?
			@ncoverreport.run
			fail if @ncoverreport.failed
		end		
	end
end
