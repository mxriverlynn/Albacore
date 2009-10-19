@root_dir = File.expand_path(File.join(File.dirname(__FILE__), "../../"))

$: << File.join(@root_dir, "lib")
$: << File.join(@root_dir, "lib/rake")
$: << File.join(@root_dir, "lib/albacore")
$: << File.join(@root_dir, "lib/albacore/support")
$: << File.join(@root_dir, "spec")
$: << File.join(@root_dir, "spec/patches")
$: << File.join(@root_dir, "spec/support")

require 'mocha'
require 'system_patch'
require 'tasklib_patch'

Spec::Runner.configure do |config|
	config.mock_with :mocha
end
