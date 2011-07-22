$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'FileUtils'

class CopyDir
	include Albacore::Task
	
	attr_accessor :src, :dest, :exclude, :delete_dest
	
	def initialize
		@exclude = []
		@delete_dest = false
	end
	
	def execute
		delete_dir @dest if @delete_dest && File.directory?(@dest)
		copydir(@src, @dest)
	end	
		
	def copydir(source, destination)		
		FileUtils.mkdir destination unless File.exists? destination

		Dir.foreach(source) do |file|
			next if exclude?(@exclude, file)
			next if file == "." || file == ".."
			
			source_file = "#{source}/#{file}"
			destination_file = "#{destination}/#{file}"
			
			if File.directory?(source_file)
				copydir source_file, destination_file
			else
				FileUtils.copy source_file, destination_file
			end
		end
	end
	
	def exclude?(exclude_files, file)
		exclude_files.each do |s|
			if file.match(/#{s}/i)
				return true
			end
		end
		return false
	end
	
	def delete_dir(dir)	
		FileUtils.rm_rf dir
		waitfor {!Dir.exists?(dir)}
	end
	
	def waitfor(&block)
		checks = 0
		until block.call || checks >10 
			sleep 0.5
			checks += 1
		end
		raise 'waitfor timeout expired' if checks > 10
	end
end