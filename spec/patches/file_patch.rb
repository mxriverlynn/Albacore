class File
	def self.open(*args)
		$file_args = *args
		super(*args)
	end
end
