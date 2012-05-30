require 'albacore/albacoretask'
require 'albacore/config/ilmergeconfig'

class IlMerge 
  TaskName = [:ilmerge, :ILMerge]
  include Albacore::Task
  include Albacore::RunCommand
  include Configuration::ILMerge

  attr_accessor :output, :resolver
  
  attr_array :parameters

  def initialize
    super()
    update_attributes ilmerge.to_hash
  end

  def assemblies *assys
    raise ArgumentError, "expected at least 2 assemblies to merge" if assys.length < 2
    @assemblies = assys
  end

  def build_parameters
    params = Array.new @parameters
    params << %Q{/out:"#{output}"}
    raise ArgumentError, "you are required to call assemblies" if @assemblies == nil
    params += @assemblies
    params
  end

  def execute
    @command ||= @resolver.resolve
    result = run_command "ILMerge", build_parameters
  end
  
end

module Albacore
  class IlMergeResolver
    include ::Configuration::ILMerge

    attr_accessor :ilmerge_path
  
    def initialize ilmerge_path=nil
      @ilmerge_path = ilmerge_path || ilmerge.ilmerge_path
    end

    def path path
      @ilmerge_path = path
    end

    def resolve
      @ilmerge_path.nil? ? find_default : @ilmerge_path
    end
    
    def find_default
      m = ['', ' (x86)'].map{|x| "C:\\Program Files#{x}\\Microsoft\\ILMerge\\ilmerge.exe" }.
        keep_if{|x| File.exists? x}.
        first
    end

  end
end

