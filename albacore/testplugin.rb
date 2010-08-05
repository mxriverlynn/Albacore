require 'lib/albacore/albacoremodel'
require 'albacore/config/testpluginconfig'

class TestPlugin
  include AlbacoreModel
  include TestPluginConfig
end
