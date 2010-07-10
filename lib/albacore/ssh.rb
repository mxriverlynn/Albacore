require 'albacore/albacoremodel'
require 'net/ssh'
require 'albacore/config/sshconfig'

class Ssh
  include AlbacoreModel
  include Configuration::Ssh
  
  attr_accessor :server, :username, :password, :port, :key, :debug
  attr_array :commands
    
  def initialize
    @commands = []
    super()
    update_attributes ssh.to_hash
  end
  
    def get_connection_options
    options = {}
    options[:verbose] = :debug if @debug == true
    options[:password] = @password if @password
    options[:port] = @port if @port
    options[:keys] = [@key] if @key
    options
  end
  
  def execute()
    warn_about_key if @key
    
    Net::SSH.start(@server, @username, get_connection_options) do |ssh|
      @commands.each{|cmd|
        @logger.info "Executing remote command: #{cmd}"
        output = ssh.exec!(cmd)
        @logger.info 'SSH output: '
        @logger.info output
      }
    end
  end
  
  def warn_about_key()
    info.debug 'When using a key, you need an SSH-Agent running to manage the keys.'
    info.debug 'On Windows, a recommended agent is called Pageant, downloadable from the Putty site.'
  end
  
end
