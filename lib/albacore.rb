$: << File.join(File.expand_path(File.dirname(__FILE__)), "albacore")
$: << File.join(File.expand_path(File.dirname(__FILE__)), "albacore", 'support')
$: << File.join(File.expand_path(File.dirname(__FILE__)), "rake")

require 'msbuild'
require 'assemblyinfo'
require 'ncoverconsole'
require 'logging'
require 'msbuildtask'
require 'assemblyinfotask'
