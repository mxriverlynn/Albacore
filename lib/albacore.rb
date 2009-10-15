$: << File.join(File.expand_path(File.dirname(__FILE__)), "albacore")
$: << File.join(File.expand_path(File.dirname(__FILE__)), "albacore", 'support')
$: << File.join(File.expand_path(File.dirname(__FILE__)), "rake")

require 'logging'

require 'msbuild'
require 'msbuildtask'

require 'assemblyinfo'
require 'assemblyinfotask'

require 'ncoverconsole'
require 'ncoverconsoletask'

require 'nunittestrunner'
require 'nunittask'

require 'mspectestrunner'

require 'sqlcmd'
require 'sqlcmdtask'
