$: << File.expand_path(File.dirname(__FILE__))
$: << File.expand_path(File.join(File.dirname(__FILE__), "albacore"))
$: << File.expand_path(File.join(File.dirname(__FILE__), "albacore", 'support'))
$: << File.expand_path(File.join(File.dirname(__FILE__), "rake"))

require 'logging'

runtime_is_ironruby = (!defined?(IRONRUBY_VERSION).nil?)

Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), 'albacore/*.rb')).reject{ |f|
  f if runtime_is_ironruby && (f.include?("ssh") || f.include?("sftp"))
}.each {|f| require f }

Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), 'rake/support/*.rb')).each {|f| require f }

Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), 'rake/*.rb')).reject{ |f|
  f if runtime_is_ironruby && (f.include?("ssh") || f.include?("sftp"))
}.each {|f| require f }
