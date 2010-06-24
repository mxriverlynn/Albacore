Dir.glob(File.join(File.dirname(__FILE__), '*.rb')).reject{|f| f == __FILE__}.each {|f| require f }
Dir.glob(File.join(File.dirname(__FILE__), '../config/*.rb')).each {|f| require f }
