@current_dir = File.expand_path(File.dirname(__FILE__))
$: << File.join(@current_dir, "lib", "rake")
$: << File.join(@current_dir, "lib")

require 'spec/rake/spectask'
require 'msbuildtask'

task :default => 'albacore:specs'

namespace :albacore do
  desc "Run functional specs for Albacore"
  Spec::Rake::SpecTask.new :specs do |t|
	t.spec_opts << '--colour'
	t.spec_opts << '--format specdoc'
    t.spec_files = FileList['lib/spec/**/*_spec.rb']
  end
end
