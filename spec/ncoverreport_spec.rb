require 'spec_helper'
require 'albacore/ncoverreport'
require 'ncoverreporttestdata'

describe NCoverReport, "when runnign without the ncover report location specified" do
  before :all do
    @ncover = NCoverReport.new
    @ncover.extend(FailPatch)
    @ncover.execute
  end
  
  it "should fail execution" do
    $task_failed.should be_true
  end
end

describe NCoverReport, "when running a full coverage report with a specified output folder" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new()
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport
    
    @ncover.execute
  end

  it "should execute ncover.reporting" do
    @ncover.system_command.should include(NCoverReportTestData.command)
  end
  
  it "should tell ncover.reporting to produce a full coverage html report in the specified folder" do
    @ncover.system_command.downcase.should include("//or FullCoverageReport:Html:\"#{NCoverReportTestData.output_folder}\"".downcase)
  end
  
  it "should produce the report" do
    File.exist?(File.join(NCoverReportTestData.output_folder, "fullcoveragereport.html")).should be_true
  end  
end

describe NCoverReport, "when running a summary report with a specified output folder" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    summaryreport = NCover::SummaryReport.new()
    summaryreport.output_path = NCoverReportTestData.summary_output_file
    @ncover.reports summaryreport
    
    @ncover.execute
  end

  it "should execute ncover.reporting" do
    @ncover.system_command.should include(NCoverReportTestData.command)
  end
  
  it "should tell ncover.reporting to produce a summary html report in the specified folder" do
    @ncover.system_command.downcase.should include("//or Summary:Html:\"#{NCoverReportTestData.summary_output_file}\"".downcase)
  end
  
  it "should produce the report" do
    File.exist?(NCoverReportTestData.summary_output_file).should be_true
  end    
end

describe NCoverReport, "when running multiple ncover reports - a summary and a full coverage report" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    summaryreport = NCover::SummaryReport.new()
    summaryreport.output_path = NCoverReportTestData.summary_output_file
    
    fullcoveragereport = NCover::FullCoverageReport.new()
    @fullcoverage_output_folder = File.join(NCoverReportTestData.output_folder, "fullcoverage")
    fullcoveragereport.output_path = @fullcoverage_output_folder
    @ncover.reports summaryreport, fullcoveragereport

    @ncover.execute
  end

  it "should tell ncover.reporting to produce a full coverage html report in the specified folder" do
    @ncover.system_command.downcase.should include("//or FullCoverageReport:Html:\"#{@fullcoverage_output_folder}\"".downcase)
  end
  
  it "should tell ncover.reporting to produce a summary html report in the specified folder" do
    @ncover.system_command.downcase.should include("//or Summary:Html:\"#{NCoverReportTestData.summary_output_file}\"".downcase)
  end
end

describe NCoverReport, "when running a report with a specified minimum symbol coverage lower than actual coverage" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport
    
    symbolcoverage = NCover::SymbolCoverage.new
    symbolcoverage.minimum = 10
    @ncover.required_coverage symbolcoverage
    
    @ncover.execute
  end

  it "should tell ncover.reporting to check for the specified minimum coverage" do
    @ncover.system_command.should include("//mc SymbolCoverage:10:View")
  end
  
  it "should not fail the execution" do
    $task_failed.should be_false
  end
  
  it "should produce the report" do
    File.exist?(File.join(NCoverReportTestData.output_folder, "fullcoveragereport.html")).should be_true
  end  
end

describe NCoverReport, "when running a report with a specified minimum symbol coverage higher than actual coverage" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport
    
    symbolcoverage = NCover::SymbolCoverage.new
    symbolcoverage.minimum = 100
    @ncover.required_coverage symbolcoverage
    
    @ncover.execute
  end

  it "should tell ncover.reporting to check for the specified minimum coverage" do
    @ncover.system_command.should include("//mc SymbolCoverage:10")
  end
  
  it "should fail the execution" do
    $task_failed.should be_true
  end
  
  it "should produce the report" do
    File.exist?(File.join(NCoverReportTestData.output_folder, "fullcoveragereport.html")).should be_true
  end  
end

describe NCoverReport, "when specifying the coverage item type to check" do
    before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    report = NCover::SummaryReport.new
    report.output_path = NCoverReportTestData.summary_output_file
    @ncover.reports report
    
    symbolcoverage = NCover::SymbolCoverage.new
    symbolcoverage.minimum = 10
    symbolcoverage.item_type = :Class
    @ncover.required_coverage symbolcoverage
    
    @ncover.execute
  end

  it "should tell ncover.reporting to check for the specified item type" do
    @ncover.system_command.should include("//mc SymbolCoverage:10:Class")
  end
  
  it "should produce the report" do
    File.exist?(NCoverReportTestData.summary_output_file).should be_true
  end  
end

describe NCoverReport, "when checking more than one type of coverage and all fail" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport
    
    @ncover.required_coverage(
    	NCover::SymbolCoverage.new(:minimum => 100, :item_type => :View),
    	NCover::BranchCoverage.new(:minimum => 10, :item_type => :Class),
    	NCover::MethodCoverage.new(:minimum => 100, :item_type => :Class)
    )

    @ncover.execute
  end

  it "should tell ncover.reporting to check for the symbol coverage" do
    @ncover.system_command.should include("//mc SymbolCoverage:100:View")
  end
  
  it "should tell ncover.reporting to check for the branch coverage" do
    @ncover.system_command.should include("//mc BranchCoverage:10:Class")
  end
  
  it "should tell ncover.reporting to check for the branch coverage" do
    @ncover.system_command.should include("//mc MethodCoverage:100:Class")
  end

  it "should produce the report" do
    File.exist?(File.join(NCoverReportTestData.output_folder, "fullcoveragereport.html")).should be_true
  end  
  
  it "should fail the execution" do
    $task_failed.should be_true
  end
end

describe NCoverReport, "when checking more than one type of coverage and all pass" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport
    
    @ncover.required_coverage(
    	NCover::SymbolCoverage.new(:minimum => 0, :item_type => :View),
    	NCover::BranchCoverage.new(:minimum => 0, :item_type => :Class),
    	NCover::MethodCoverage.new(:minimum => 0, :item_type => :Class)
    )

    @ncover.execute
  end

  it "should tell ncover.reporting to check for the symbol coverage" do
    @ncover.system_command.should include("//mc SymbolCoverage:0:View")
  end
  
  it "should tell ncover.reporting to check for the branch coverage" do
    @ncover.system_command.should include("//mc BranchCoverage:0:Class")
  end
  
  it "should tell ncover.reporting to check for the method coverage" do
    @ncover.system_command.should include("//mc MethodCoverage:0:Class")
  end

  it "should produce the report" do
    File.exist?(File.join(NCoverReportTestData.output_folder, "fullcoveragereport.html")).should be_true
  end  
  
  it "should not fail the execution" do
    $task_failed.should be_false
  end
end

describe NCoverReport, "when checking more than one type of coverage and one fails" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport
    
    @ncover.required_coverage(
    	NCover::SymbolCoverage.new(:minimum => 100, :item_type => :View),
    	NCover::BranchCoverage.new(:minimum => 0, :item_type => :Class)
    )

    @ncover.execute
  end

  it "should tell ncover.reporting to check for the symbol coverage" do
    @ncover.system_command.should include("//mc SymbolCoverage:100:View")
  end
  
  it "should tell ncover.reporting to check for the branch coverage" do
    @ncover.system_command.should include("//mc BranchCoverage:0:Class")
  end
  
  it "should produce the report" do
    File.exist?(File.join(NCoverReportTestData.output_folder, "fullcoveragereport.html")).should be_true
  end  
  
  it "should fail the execution" do
    $task_failed.should be_true
  end
end

describe NCoverReport, "when running a report with a cyclomatic complexity higher than allowed" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport
    
    coverage = NCover::CyclomaticComplexity.new(:maximum => 1, :item_type => :Class)
    @ncover.required_coverage coverage
    
    @ncover.execute
  end

  it "should tell ncover.reporting to check for the maximum cyclomatic complexity" do
    @ncover.system_command.should include("//mc CyclomaticComplexity:1:Class")
  end
  
  it "should fail the execution" do
    $task_failed.should be_true
  end
  
  it "should produce the report" do
    File.exist?(File.join(NCoverReportTestData.output_folder, "fullcoveragereport.html")).should be_true
  end  
end

describe NCoverReport, "when running a report with a cyclomatic complexity under the limit" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport
    
    coverage = NCover::CyclomaticComplexity.new(:maximum => 1000)
    @ncover.required_coverage coverage
    
    @ncover.execute
  end

  it "should tell ncover.reporting to check for the maximum cyclomatic complexity" do
    @ncover.system_command.should include("//mc CyclomaticComplexity:1000:View")
  end
  
  it "should not fail the execution" do
    $task_failed.should be_false
  end
  
  it "should produce the report" do
    File.exist?(File.join(NCoverReportTestData.output_folder, "fullcoveragereport.html")).should be_true
  end  
end

describe NCoverReport, "when filtering on Assembly coverage data" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport    
    @ncover.required_coverage NCover::SymbolCoverage.new(:minimum => 0)
    
    @ncover.filters(
    	NCover::AssemblyFilter.new(:filter_type => :exclude, :filter => "nunit.*"),
    	NCover::AssemblyFilter.new(:filter_type => :include, :filter => "TestSolution.*")
    )
    
    @ncover.execute
  end
  
  it "should exclude the specified assemblies data" do
    @ncover.system_command.should include("//cf \"nunit.*\":Assembly:false:false")
  end

  it "should include the specified assemblies data" do
    @ncover.system_command.should include("//cf \"TestSolution.*\":Assembly:false:true")
  end
  
  it "should not fail" do
    $task_failed.should be_false
  end
end

describe NCoverReport, "when filtering on Namespace coverage data" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport    
    @ncover.required_coverage NCover::SymbolCoverage.new(:minimum => 0)
    
    @ncover.filters(
    	NCover::NamespaceFilter.new(:filter_type => :exclude, :filter => "nunit.*"),
    	NCover::NamespaceFilter.new(:filter_type => :include, :filter => "TestSolution.*")
    )
    
    @ncover.execute
  end
  
  it "should exclude the specified data" do
    @ncover.system_command.should include("//cf \"nunit.*\":Namespace:false:false")
  end

  it "should include the specified data" do
    @ncover.system_command.should include("//cf \"TestSolution.*\":Namespace:false:true")
  end
  
  it "should not fail" do
    $task_failed.should be_false
  end
end

describe NCoverReport, "when filtering on Class coverage data" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport    
    @ncover.required_coverage NCover::SymbolCoverage.new(:minimum => 0)
    
    @ncover.filters(
    	NCover::ClassFilter.new(:filter_type => :exclude, :filter => "Foo"),
    	NCover::ClassFilter.new(:filter_type => :include, :filter => "Bar")
    )
    
    @ncover.execute
  end
  
  it "should exclude the specified data" do
    @ncover.system_command.should include("//cf \"Foo\":Class:false:false")
  end

  it "should include the specified data" do
    @ncover.system_command.should include("//cf \"Bar\":Class:false:true")
  end
  
  it "should not fail" do
    $task_failed.should be_false
  end
end

describe NCoverReport, "when filtering on Method coverage data" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport    
    @ncover.required_coverage NCover::SymbolCoverage.new(:minimum => 0)
    
    @ncover.filters(
    	NCover::MethodFilter.new(:filter_type => :exclude, :filter => "Foo"),
    	NCover::MethodFilter.new(:filter_type => :include, :filter => "Bar")
    )
    
    @ncover.execute
  end
  
  it "should exclude the specified data" do
    @ncover.system_command.should include("//cf \"Foo\":Method:false:false")
  end

  it "should include the specified data" do
    @ncover.system_command.should include("//cf \"Bar\":Method:false:true")
  end
  
  it "should not fail" do
    $task_failed.should be_false
  end
end

describe NCoverReport, "when filtering on Document coverage data" do
  before :all do
    NCoverReportTestData.clean_output_folder
    
    @ncover = NCoverReport.new
    @ncover.extend(SystemPatch)
    @ncover.extend(FailPatch)
    @ncover.log_level = :verbose
    
    @ncover.command = NCoverReportTestData.command
    @ncover.coverage_files NCoverReportTestData.coverage_file
    
    fullcoveragereport = NCover::FullCoverageReport.new
    fullcoveragereport.output_path = NCoverReportTestData.output_folder
    @ncover.reports fullcoveragereport    
    @ncover.required_coverage NCover::SymbolCoverage.new(:minimum => 0)
    
    @ncover.filters(
    	NCover::DocumentFilter.new(:filter_type => :exclude, :filter => "Foo"),
    	NCover::DocumentFilter.new(:filter_type => :include, :filter => "Bar")
    )
    
    @ncover.execute
  end
  
  it "should exclude the specified data" do
    @ncover.system_command.should include("//cf \"Foo\":Document:false:false")
  end

  it "should include the specified data" do
    @ncover.system_command.should include("//cf \"Bar\":Document:false:true")
  end
  
  it "should not fail" do
    $task_failed.should be_false
  end
end

describe NCoverReport, "when providing configuration values" do
  let :ncoverreport do
    Albacore.configure do |config|
      config.ncoverreport.command = "configured"
    end
    ncoverreport = NCoverReport.new
  end

  it "should use the configured values" do
    ncoverreport.command.should == "configured"
  end
end
