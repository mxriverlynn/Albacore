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
    self.mixin_config_module mod
    self.create_rake_task mod
  end

  def self.mixin_config_module(objtoconfig)
    configdir = File.expand_path(File.join(Albacore.configure.plugindir, "config"))
    classname = objtoconfig.to_s
    configfilename = File.expand_path(File.join(configdir, "#{classname.downcase}config.rb"))
    modulename = classname + "Config"

    if File.exist? configfilename
      begin
        require "#{configfilename}"
        configmodule = Kernel.const_get modulename
        objtoconfig.send(:include, configmodule)
      end
    end
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
