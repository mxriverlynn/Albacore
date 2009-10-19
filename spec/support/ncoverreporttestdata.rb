class NCoverReportTestData
	
	@filedir = File.dirname(__FILE__)
	
	def self.path_to_command
		File.expand_path(File.join(@filedir, "Tools", "NCover-v3.3", "NCover.Reporting.exe"))
	end
end