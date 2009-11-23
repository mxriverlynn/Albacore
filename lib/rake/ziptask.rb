require 'rake/tasklib'

module Albacore
	class ZipTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:zip, &block)
			@name = name
			@zip = ZipDirectory.new
			@block = block
			define
		end
		
		def define
			task name do
				@block.call(@zip) unless @block.nil?
				@zip.package
			end
		end		
	end
end