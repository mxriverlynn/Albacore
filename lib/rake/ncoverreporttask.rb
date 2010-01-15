require 'rake/tasklib'

def ncoverreport(name=:ncoverreport, *args, &block)
  Albacore::NCoverReportTask.new(name, *args, &block)
end
  
module Albacore
  class NCoverReportTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      @ncoverreport = NCoverReport.new
      @ncoverreport.load_config_by_task_name(name)
      @block.call(@ncoverreport, *task_args) unless @block.nil?
      @ncoverreport.run
      fail if @ncoverreport.failed
    end    
  end
end
