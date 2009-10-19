Spec::Runner.configure do |config|
	config.mock_with :mocha
end

Mocha::Configuration.prevent(:stubbing_non_existent_method)
