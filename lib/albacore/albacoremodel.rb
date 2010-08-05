require 'albacore/support/attrmethods'
require 'albacore/support/failure'
require 'albacore/support/logging'
require 'albacore/support/yamlconfig'
require 'albacore/support/runcommand'
require 'rake/createtask'
require 'albacore/config/config'

module AlbacoreModel
  include Failure
  include Logging
  include YAMLConfig

  def self.included(mod)
    mod.extend AttrMethods
    self.mixin_config_module mod
    self.create_rake_task mod
  end

  def update_attributes(attrs)
    attrs.each do |key, value|
      setter = "#{key}="
      send(setter, value) if respond_to?(setter)
      @logger.warn "#{key} is not a settable attribute on #{self.class}" unless respond_to?(setter)
    end
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
      create_task mod.name.downcase, mod
    end
  end

  def <<(attrs)
    update_attributes attrs
  end
end
