class ExpandTemplatesTestData
	
	def initialize
		@rootfolder = File.join(File.dirname(__FILE__), "expandtemplates")
		@templatefolder = File.join(@rootfolder, "templates")
		@workingfolder = File.join(@rootfolder, "working")
		@outputfolder = File.join(@rootfolder, "output")
		@datafilesfolder = File.join(@rootfolder, "datafiles")
	end

	def prep_sample_templates
		FileUtils.rm(Dir.glob(File.join(@workingfolder, "*")))
		sleep(1)
		
		Dir.glob(File.join(@templatefolder, "*")){|f|
			FileUtils.copy(f, @workingfolder)
		}
	end
	
	def sample_template_file
		File.join(@workingfolder, "sample.config")
	end
	
	def sample_data_file
		File.join(@datafilesfolder, "sample.yml")
	end
	
end