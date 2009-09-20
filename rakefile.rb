# require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'spec/rake/spectask'
require 'lib/rake/msbuildtask'

task :default => 'spec:test'

namespace :spec do
  desc "Run functional specs"
  Spec::Rake::SpecTask.new :test do |t|
	t.spec_opts << '--colour'
	t.spec_opts << '--format specdoc'
    t.spec_files = FileList['lib/spec/**/*_spec.rb']
  end
end
