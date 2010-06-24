require 'ostruct'

module Configuration
  module MSBuild
    @config = OpenStruct.new.extend(MSBuild)
    def self.msbuildconfig
      @config
    end

    def msbuild
      @config ||= MSBuild.msbuildconfig
    end

    def self.included(mod)
      self.msbuildconfig.use :net40
    end

    def use(netversion)
      win_dir = ENV['windir'] || ENV['WINDIR'] || "C:/Windows"
      case netversion
        when :net2, :net20
          path = File.join(win_dir.dup, 'Microsoft.NET', 'Framework', 'v2.0.50727', 'MSBuild.exe')
        when :net35
          path = File.join(win_dir.dup, 'Microsoft.NET', 'Framework', 'v3.5', 'MSBuild.exe')
        when :net4, :net40
          path = File.join(win_dir.dup, 'Microsoft.NET', 'Framework', 'v4.0.30319', 'MSBuild.exe')
        else
          fail "#{netversion} is not a supported .net version for msbuild"
      end
      msbuild.path = path
    end

    Albacore.configuration.extend(self)
  end
end
