require 'albacore/support/attrmethods'
require 'albacore/support/failure'
require 'albacore/support/logging'
require 'albacore/support/yamlconfig'
require 'albacore/support/runcommand'
require 'albacore/config/config'

module AlbacoreModel
  include Failure
  include Logging
  include YAMLConfig

  def self.included(obj)
    obj.extend AttrMethods
  end
end
