require 'rake/tasklib'
require 'albacore/zipdirectory'

module Albacore
	class ZipTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:zip)
			@name = name
			@zip = ZipDirectory.new
			yield @zip if block_given?
			define
		end
		
		def define
			task name do
				@zip.package
			end
		end		
	end
end