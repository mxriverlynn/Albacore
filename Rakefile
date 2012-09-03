require 'semver'
require 'bundler'
Bundler::GemHelper.install_tasks

task :default => ['spec:all']

namespace :specs do
  require 'rspec/core/rake_task'

  @rspec_opts = ['--colour --format documentation']

  desc "Run all specs for albacore"
  RSpec::Core::RakeTask.new :all do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = @rspec_opts
  end

  exceptNCov = []
  # generate tasks for each *_spec.rb file in the root spec folder
  FileList['spec/*_spec.rb'].each do |fname|
    spec = $1 if /spec\/(.+)_spec\.rb/ =~ fname
    exceptNCov << spec unless /ncover|ndepend/ =~ spec
    desc "Run #{spec} specs"
    RSpec::Core::RakeTask.new spec do |t|
      t.pattern = "spec/#{spec}*_spec.rb"
      t.rspec_opts = @spec_opts
    end
  end

  #quick hack to run all specs not in ncover or ndepend, to evaluate changes
  desc "excludes ncover  and ndepend specs"
  task :except_ncover => exceptNCov

  desc "MSDeploy functional specs"
  RSpec::Core::RakeTask.new :msdeploy do |t|
    t.pattern = 'spec/msdeploy*_spec.rb'
    t.rspec_opts = @rspec_opts
  end

end
