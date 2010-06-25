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

  def update_attributes(attrs)
    attrs.each do |key, value|
      setter = "#{key}="
      send(setter, value) if respond_to?(setter)
      @logger.warn "#{key} is not a settable attribute on #{self.class}" unless respond_to?(setter)
    end
  end

  def <<(attrs)
    update_attributes attrs
  end
end
