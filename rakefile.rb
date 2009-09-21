require 'spec/rake/spectask'
require 'lib/albacore'

task :default => 'albacore:specs'

namespace :albacore do
  desc "Run functional specs for the Albacore framework"
  Spec::Rake::SpecTask.new :specs do |t|
	t.spec_opts << '--colour'
	t.spec_opts << '--format specdoc'
    t.spec_files = FileList['lib/spec/**/*_spec.rb']
  end
end

namespace :albacore do
	desc "Run a sample build using the MSBuildTask"
	Rake::MSBuildTask.new(:msbuild) do |msb|
		msb.properties = {:configuration => :debug}
		msb.targets = [:Clean, :Build]
		msb.solution = "lib/spec/support/TestSolution/TestSolution.sln"
	end
end