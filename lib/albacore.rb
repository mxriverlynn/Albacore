albacore_root = File.expand_path(File.dirname(__FILE__))
$: << albacore_root

IS_IRONRUBY = (defined?(RUBY_ENGINE) && RUBY_ENGINE == "ironruby")

Dir.glob(File.join(albacore_root, 'albacore/*.rb')).each {|f| require f }
