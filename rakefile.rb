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
  #].exclude{ |f| 
  #  f if IS_IRONRUBY && (f.include?("zip")) 
  #}
  
  desc "CSharp compiler (csc.exe) specs" 
  RSpec::Core::RakeTask.new :csc do |t|
    t.pattern = 'spec/csc*_spec.rb'
    t.rspec_opts = @rspec_opts
  end

  desc "Assembly info functional specs"
  RSpec::Core::RakeTask.new :assemblyinfo do |t|
    t.pattern = 'spec/assemblyinfo*_spec.rb'
    t.rspec_opts = @rspec_opts
  end
  
  desc "MSBuild functional specs"
  RSpec::Core::RakeTask.new :msbuild do |t|
    t.pattern = 'spec/msbuild*_spec.rb'
    t.rspec_opts = @rspec_opts
  end

  desc "SQLServer SQLCmd functional specs" 
  RSpec::Core::RakeTask.new :sqlcmd do |t|
    t.pattern = 'spec/sqlcmd*_spec.rb'
    t.rspec_opts = @rspec_opts
  end
  
  desc "Nant functional specs"
  RSpec::Core::RakeTask.new :nant do |t|
    t.pattern = 'spec/nant*_spec.rb'
    t.rspec_opts = @rspec_opts
  end
  
  desc "NCover Console functional specs"
  RSpec::Core::RakeTask.new :ncoverconsole do |t|
    t.pattern = 'spec/ncoverconsole*_spec.rb'
    t.rspec_opts = @rspec_opts
  end
  
  desc "NCover Report functional specs"
  RSpec::Core::RakeTask.new :ncoverreport do |t|
    t.pattern = 'spec/ncoverreport*_spec.rb'
    t.rspec_opts = @rspec_opts
  end

  desc "Ndepend functional specs"
  RSpec::Core::RakeTask.new :ndepend do |t|
    t.pattern = 'spec/ndepend*_spec.rb'
    t.rspec_opts = @rspec_opts
  end
  
  desc "NuSpec functional specs"
  RSpec::Core::RakeTask.new :nuspec do |t|
    t.pattern = 'spec/nuspec*_spec.rb'
    t.rspec_opts = @rspec_opts
  end

  desc "Zip functional specs"
  RSpec::Core::RakeTask.new :zip do |t|
    t.pattern = 'spec/zip*_spec.rb'
    t.rspec_opts = @rspec_opts
    end

  desc "XUnit functional specs"
  RSpec::Core::RakeTask.new :xunit do |t|
    t.pattern = 'spec/xunit*_spec.rb'
    t.rspec_opts = @rspec_opts
  end

  desc "NUnit functional specs"
  RSpec::Core::RakeTask.new :nunit do |t|
    t.pattern = 'spec/nunit*_spec.rb'
    t.rspec_opts = @rspec_opts
  end

  desc "MSTest functional specs"
  RSpec::Core::RakeTask.new :mstest do |t|
    t.pattern = 'spec/mstest*_spec.rb'
    t.rspec_opts = @rspec_opts
  end

  desc "MSpec functional specs"
  RSpec::Core::RakeTask.new :mspec do |t|
    t.pattern = 'spec/mspec*_spec.rb'
    t.rspec_opts = @rspec_opts
  end

  desc "Exec functional specs"
  RSpec::Core::RakeTask.new :exec do |t|
    t.pattern = 'spec/exec*_spec.rb'
    t.rspec_opts = @rspec_opts
  end
  
  desc "Docu functional specs"
  RSpec::Core::RakeTask.new :docu do |t|
    t.pattern = 'spec/docu*_spec.rb'
    t.rspec_opts = @rspec_opts
  end

  desc "YAML Config functional specs"
  RSpec::Core::RakeTask.new :yamlconfig do |t|
    t.pattern = 'spec/yaml*_spec.rb'
    t.rspec_opts = @rspec_opts
  end

  desc "FluenMigrator functional specs"
  RSpec::Core::RakeTask.new :fluentmigrator do |t|
    t.pattern = 'spec/fluentmigrator*_spec.rb'
    t.rspec_opts = @rspec_opts
  end	
  
  desc "Output functional specs"
  RSpec::Core::RakeTask.new :output do |t|
    t.pattern = 'spec/output*_spec.rb'
    t.rspec_opts = @rspec_opts
  end
    
  desc "NChurn functional specs"
  RSpec::Core::RakeTask.new :nchurn do |t|
    t.pattern = 'spec/nchurn*_spec.rb'
    t.rspec_opts = @rspec_opts
  end
    
  desc "ILMerge unit tests"
  RSpec::Core::RakeTask.new :ilmerge do |t|
    t.pattern = 'spec/ilmerge*_spec.rb'
    t.rspec_opts = @rspec_opts
  end
    
  desc "ILMerge unit tests"
  Spec::Rake::SpecTask.new :ilmerge do |t|
    t.spec_files = FileList['spec/ilmerge*_spec.rb']
    t.spec_opts << @spec_opts
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
