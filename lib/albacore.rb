$: << File.expand_path(File.dirname(__FILE__))
$: << File.expand_path(File.join(File.dirname(__FILE__), "albacore"))
$: << File.expand_path(File.join(File.dirname(__FILE__), "albacore", 'support'))
$: << File.expand_path(File.join(File.dirname(__FILE__), "rake"))

require 'logging'

Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), 'rake/support/*.rb')).each {|f| require f }
Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), 'rake/*.rb')).each {|f| require f }
Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), 'albacore/*.rb')).each {|f| require f }
