require 'albacore/support/attrmethods'
require 'albacore/support/failure'
require 'albacore/support/logging'
require 'albacore/support/yamlconfig'
require 'albacore/support/runcommand'
require 'albacore/support/updateattributes'
require 'rake/createtask'
require 'albacore/config/config'

module AlbacoreModel
  module TaskName
    def task_name
      @task_name
    end
  end
end

module AlbacoreModel
  include Failure
  include Logging
  include YAMLConfig
  include UpdateAttributes

  def self.included(mod)
    mod.extend AttrMethods
    mod.extend AlbacoreModel::TaskName
    self.create_rake_task mod
  end

  def self.create_rake_task(mod)
    if mod.class == Class
      tasknames = Array.new
      tasknames << (mod.task_name || mod.name.downcase)
      tasknames.flatten.each do |taskname|
        create_task taskname, mod
      end
    end
  end
end
