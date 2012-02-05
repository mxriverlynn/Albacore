$: << './'
require 'psych'
require 'lib/albacore'
require 'version_bumper'

task :default => ['albacore:sample']
task :install => ['jeweler:gemspec', 'jeweler:build'] do
  sh "gem install -l pkg/albacore-#{File.open('VERSION', 'rb').read}.gem"
end

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
  task :except_ncover => exceptNCov do
  end
end

namespace :albacore do  
  Albacore.configure do |config|
    config.yaml_config_folder = "spec/support/yamlconfig"
    config.log_level = :verbose
  end

  desc "Run a complete Albacore build sample"
  task :sample => ['albacore:assemblyinfo',
                   'albacore:assemblyinfo_modify',
                   'albacore:msbuild',
                   'albacore:ncoverconsole',
                   'albacore:ncoverreport',
                   'albacore:mspec',
                   'albacore:nunit',
                   'albacore:xunit',
                   'albacore:mstest',
                   'albacore:fluentmigrator']
  
  desc "Run a sample MSBuild with YAML autoconfig"
  msbuild :msbuild
  
  desc "Run a sample assembly info generator"
  assemblyinfo do |asm|
    asm.version = "0.1.2.3"
    asm.company_name = "a test company"
    asm.product_name = "a product name goes here"
    asm.title = "my assembly title"
    asm.description = "this is the assembly description"
    asm.copyright = "copyright some year, by some legal entity"
    asm.custom_attributes :SomeAttribute => "some value goes here", :AnotherAttribute => "with some data"
    
    asm.output_file = "spec/support/AssemblyInfo/AssemblyInfo.cs"
  end

  desc "Run a sample assembly info modifier"
  assemblyinfo :assemblyinfo_modify do|asm|
    # modify existing
    asm.version = "0.1.2.3"
    asm.company_name = "a test company"

    # new attribute
    asm.file_version = "4.5.6.7"

    asm.input_file = "spec/support/AssemblyInfo/AssemblyInfoInput.test"
    asm.output_file = "spec/support/AssemblyInfo/AssemblyInfoOutput.cs"
  end
  
  desc "Run a sample NCover Console code coverage"
  ncoverconsole do |ncc|
    @xml_coverage = "spec/support/CodeCoverage/test-coverage.xml"
    File.delete(@xml_coverage) if File.exist?(@xml_coverage)
    
    ncc.log_level = :verbose
    ncc.command = "spec/support/Tools/NCover-v3.3/NCover.Console.exe"
    ncc.output :xml => @xml_coverage
    ncc.working_directory = "spec/support/CodeCoverage/nunit"
    
    nunit = NUnitTestRunner.new("spec/support/Tools/NUnit-v2.5/nunit-console-x86.exe")
    nunit.log_level = :verbose
    nunit.assemblies "assemblies/TestSolution.Tests.dll"
    nunit.options '/noshadow'
    
    ncc.testrunner = nunit
  end  
  
  desc "Run a sample NCover Report to check code coverage"
  ncoverreport :ncoverreport => :ncoverconsole do |ncr|
    @xml_coverage = "spec/support/CodeCoverage/test-coverage.xml"
    
    ncr.command = "spec/support/Tools/NCover-v3.3/NCover.Reporting.exe"
    ncr.coverage_files @xml_coverage
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = "spec/support/CodeCoverage/report/output"
    ncr.reports fullcoveragereport
    
    ncr.required_coverage(
    	NCover::BranchCoverage.new(:minimum => 10),
    	NCover::CyclomaticComplexity.new(:maximum => 1)
    )
  end

  desc "Run ZipDirectory example"
  zip do |zip|
    zip.output_path = File.dirname(__FILE__)
    zip.directories_to_zip = "lib", "spec"
    zip.additional_files "README.markdown"
    zip.output_file = 'albacore_example.zip'
  end
  
  desc "Run UnZip example"
  unzip do |zip|
    zip.unzip_path = File.join File.dirname(__FILE__), 'temp'
    zip.zip_file = 'albacore_example.zip'
  end
   
  desc "MSpec Test Runner Example"
  mspec do |mspec|
    mspec.command = "spec/support/Tools/Machine.Specification-v0.2/Machine.Specifications.ConsoleRunner.exe"
    mspec.assemblies "spec/support/CodeCoverage/mspec/assemblies/TestSolution.MSpecTests.dll"
  end

  desc "NUnit Test Runner Example"
  nunit do |nunit|
    nunit.command = "spec/support/Tools/NUnit-v2.5/nunit-console.exe"
    nunit.assemblies "spec/support/CodeCoverage/nunit/assemblies/TestSolution.Tests.dll"
  end

  desc "MSTest Test Runner Example"
  mstest do |mstest|
    mstest.command = "spec/support/Tools/MSTest-2010/mstest.exe"
    mstest.assemblies "spec/support/CodeCoverage/mstest/TestSolution.MsTestTests.dll"
  end

  desc "XUnit Test Runner Example"
  xunit do |xunit|
    xunit.command = "spec/support/Tools/XUnit-v1.5/xunit.console.exe"
    xunit.assembly = "spec/support/CodeCoverage/xunit/assemblies/TestSolution.XUnitTests.dll"
  end   
  
  desc "Exec Task Example"
  exec do |exec|
    exec.command = 'hostname'
  end   
  
  desc "Mono \ xBuild Example"
  mono do |xbuild|
    xbuild.properties :configuration => :release, :platform => 'Any CPU'
    xbuild.targets :clean, :build
    xbuild.solution = "spec/support/TestSolution/TestSolution.sln"
  end

  desc "FluentMigrator Test Runner Example"
  fluentmigrator do |migrator|
    db_file = "#{ENV['TEMP']}/fluentmigrator.sqlite3"
    File.delete(db_file) if File.exist?(db_file) 
    
    migrator.command = "spec/support/Tools/FluentMigrator-0.9/Migrate.exe"
    migrator.target = "spec/support/FluentMigrator/TestSolution.FluentMigrator.dll"
    migrator.provider = "sqlite"
    migrator.connection = "Data Source=#{db_file};"
  end

desc "This is my Task"
msdeploy :msdeploy do |msdeploy|
  puts "Msdeploy task"
  msdeploy.package = "spec/support/TestSolution/TestSolution.MSDeploy/TestSolution.MSDeploy/obj/Debug/Package"
  msdeploy.noop = true
  #msdeploy.parameters = "lol"
end

desc "This is my Task"
msdeploy :msdeploy2 do |msdeploy|
  puts "Msdeploy 2 task"
  msdeploy.package = "spec/support/TestSolution/TestSolution.MSDeploy/TestSolution.MSDeploy/obj/Release/Package"
  msdeploy.noop = true
  #msdeploy.parameters = "lol"
end

desc "This is my Task"
msdeploy :msdeploy3 do |msdeploy|
  puts "Msdeploy 3 task"
  msdeploy.package = "spec/support/TestSolution/TestSolution.MSDeploy/TestSolution.MSDeploy/obj/Release/Package"
  msdeploy.username="testusername"
  msdeploy.server="testserver"
  msdeploy.password="testpassword"
  msdeploy.noop = true
  #msdeploy.parameters = "lol"
end

end

namespace :jeweler do
  require 'jeweler'  
  Jeweler::Tasks.new do |gs|
    gs.name = "albacore"
    gs.summary = "Dolphin-Safe Rake Tasks For .NET Systems"
    gs.description = "Easily build your .NET solutions with Ruby and Rake, using this suite of Rake tasks."
    gs.email = "albacorebuild@gmail.com"
    gs.homepage = "http://albacorebuild.net"
    gs.authors = ["Derick Bailey", "etc"]
    gs.has_rdoc = false  
    gs.files.exclude(
      "albacore.gemspec", 
      ".gitignore", 
      "spec/",
      "pkg/"
    )
  end
end
