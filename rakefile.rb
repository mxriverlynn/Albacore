require 'spec/rake/spectask'
require 'lib/msbuildtask'

namespace :spec do
  desc "Run functional specs"
  Spec::Rake::SpecTask.new :test do |t|
	t.spec_opts << '--colour'
	t.spec_opts << '--format specdoc'
	t.spec_opts << '--loadby mtime'
	t.spec_opts << '--reverse'
    t.spec_files = FileList['lib/spec/**/*_spec.rb']
  end
end