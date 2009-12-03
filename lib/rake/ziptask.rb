require 'rake/tasklib'

module Albacore
	class ZipTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:zip, &block)
			@name = name
			@block = block
			define
		end
		
		def define
			task name do
				@zip = ZipDirectory.new
				@block.call(@zip) unless @block.nil?
				@zip.package
				fail if @zip.failed
			end
		end		
	end
end