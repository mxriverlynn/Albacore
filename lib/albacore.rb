$: << File.join(File.expand_path(File.dirname(__FILE__)), "albacore")
$: << File.join(File.expand_path(File.dirname(__FILE__)), "albacore", 'support')
$: << File.join(File.expand_path(File.dirname(__FILE__)), "rake")

require 'logging'

require 'msbuild'
require 'assemblyinfo'
require 'ncoverconsole'

require 'msbuildtask'
require 'assemblyinfotask'
require 'ncoverconsoletask'

require 'nunittestrunner'
