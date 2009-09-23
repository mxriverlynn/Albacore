Gem::Specification.new do |s| 
	s.name = "Albacore"
	s.version = "0.0.1"
	s.author = "Derick Bailey"
	s.email = "derickbailey@gmail.com"
	s.homepage = "http://github.com/derickbailey/Albacore"
	s.platform = Gem::Platform::RUBY
	s.summary = "A Suite of Rake Build Tasks For .Net Solutions"
	s.files = [
		"rakefile.rb",
		"EULA.txt",
		"lib/albacore",
		"lib/albacore/assemblyinfo.rb",
		"lib/albacore/msbuild.rb",
		"lib/albacore/patches",
		"lib/albacore/patches/buildparameters.rb",
		"lib/albacore.rb",
		"lib/rake",
		"lib/rake/assemblyinfo.rb",
		"lib/rake/msbuildtask.rb",
		"lib/spec",
		"lib/spec/assemblyinfo_spec.rb",
		"lib/spec/assemblyinfotask_spec.rb",
		"lib/spec/msbuildtask_spec.rb",
		"lib/spec/msbuild_spec.rb",
		"lib/spec/patches",
		"lib/spec/patches/system_patch.rb",
		"lib/spec/support",
		"lib/spec/support/AssemblyInfo",
		"lib/spec/support/assemblyinfotester.rb",
		"lib/spec/support/msbuildtestdata.rb",
		"lib/spec/support/spec_helper.rb",
		"lib/spec/support/TestSolution",
		"lib/spec/support/TestSolution/TestSolution",
		"lib/spec/support/TestSolution/TestSolution/Class1.cs",
		"lib/spec/support/TestSolution/TestSolution/Properties",
		"lib/spec/support/TestSolution/TestSolution/Properties/AssemblyInfo.cs",
		"lib/spec/support/TestSolution/TestSolution/TestSolution.csproj",
		"lib/spec/support/TestSolution/TestSolution.sln"
	]
	s.require_path = "lib"
	s.has_rdoc = false	
end
