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
	
	def multipleinstance_template_file
		File.join(@workingfolder, "multipleinstance.config")
	end
	
	def sample_output_file
		File.join(@workingfolder, "this_is_an_output_file.config")
	end
	
	def multiplevalues_template_file
		File.join(@workingfolder, "multiplevalues.config")
	end
	
	def multiplevalues_output_file
		File.join(@workingfolder, "multiplevalues_output_file.config")
	end
	
	def sample_data_file
		File.join(@datafilesfolder, "sample.yml")
	end
	
	def multiplevalues_data_file
		File.join(@datafilesfolder, "multiplevalues.yml")
	end
	
	def multitemplate_data_file
		File.join(@datafilesfolder, "multitemplate.yml")
	end
	
	def read_file(file)
		filedata = ''
		File.open(file, "r") {|f|
    		filedata = f.read
		}
		filedata
	end
	
end