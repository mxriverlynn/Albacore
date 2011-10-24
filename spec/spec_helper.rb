@root_dir = File.expand_path(File.join(File.dirname(__FILE__), "../"))

$: << './'
$: << File.join(@root_dir, "lib")
$: << File.join(@root_dir, "spec")
$: << File.join(@root_dir, "spec/patches")
$: << File.join(@root_dir, "spec/support")
$: << File.join(@root_dir, "lib/albacore/config")

require 'rubygems'
require 'rake/tasklib'
require 'lib/albacore/support/createtask.rb'
require 'lib/albacore/config/config.rb'
require 'lib/albacore'
require 'system_patch'
require 'fail_patch'
