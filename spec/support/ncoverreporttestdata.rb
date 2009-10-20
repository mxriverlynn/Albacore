class NCoverReportTestData
	@filedir = File.dirname(__FILE__)
	@output_folder = File.expand_path(File.join(@filedir, "CodeCoverage", "report", "output"))
	
	def self.path_to_command
		File.expand_path(File.join(@filedir, "Tools", "NCover-v3.3", "NCover.Reporting.exe"))
	end
	
	def self.coverage_file
		File.expand_path(File.join(@filedir, "CodeCoverage", "report", "coverage.xml"))
	end
	
	def self.output_folder
		@output_folder
	end
	
	def self.clean_output_folder
		FileUtils.rmtree(@output_folder)
		Dir.mkdir(@output_folder) unless File.exist?(@output_folder)
		sleep(3)
	end
	
	def self.summary_output_file
		File.join(NCoverReportTestData.output_folder, "summary.html")
	end
end