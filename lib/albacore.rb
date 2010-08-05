albacore_root = File.expand_path(File.dirname(__FILE__))
$: << albacore_root
$: << File.join(albacore_root, "albacore")
$: << File.join(albacore_root, "albacore", 'support')
$: << File.join(albacore_root, "albacore", 'config')
$: << File.join(albacore_root, "rake")

require 'logging'
runtime_is_ironruby = (!defined?(IRONRUBY_VERSION).nil?)
Dir.glob(File.join(albacore_root, 'albacore/*.rb')).each {|f| require f }
Dir.glob(File.join(albacore_root, 'rake/support/*.rb')).each {|f| require f }
Dir.glob(File.join(albacore_root, 'rake/*.rb')).each {|f| require f }

module Albacore
  def self.load_tasks(task_directory)
    Dir.glob(File.join(task_directory, "*.rb")).each do |f| 
      require f 
    end
  end

  Albacore.load_tasks(Albacore.configuration.plugindir)
  # Albacore.load_tasks(File.join(albacore_root, "albacore")
end
