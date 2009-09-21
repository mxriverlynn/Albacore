module HashParameterBuilder
	def build_parameters
		option_text = ''
		self.each do |key, value|
			option_text << "#{key}\=#{value};"
		end
		option_text.chop
	end
end

module ArrayParameterBuilder
	def build_parameters
		option_text = ''
		self.each do |value|
			option_text << "#{value};"
		end
		option_text.chop
	end
end