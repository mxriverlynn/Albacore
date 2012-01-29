require 'spec_helper'
require 'albacore/nugetupdate'
require 'albacore/config/nugetupdateconfig'

describe NuGetUpdate do  
  before :each do
    @nugetupdate = NuGetUpdate.new
    @strio = StringIO.new
    @nugetupdate.log_device = @strio
    @nugetupdate.log_level = :diagnostic
  end
  
  context "when no path to NuGet is specified" do
    it "assumes NuGet is in the path" do
      @nugetupdate.command.should == "NuGet.exe"
    end
  end

  it "generates the correct command-line parameters" do
    @nugetupdate.input_file = "../support/TestSolution/TestSolution.sln"
    @nugetupdate.source = "source1", "source2"
    @nugetupdate.id = "id1", "id2"
    @nugetupdate.repository_path = "repopath"
    
    params = @nugetupdate.get_command_parameters
    params.should include(@nugetupdate.input_file)
    params.should include("-Source \"source1;source2\"")
    params.should include("-Id \"id1;id2\"")
    params.should include("-RepositoryPath repopath")
    params.should_not include("-Self")
    
    @nugetupdate.safe = true
    params = @nugetupdate.get_command_parameters
    params.should include("-Safe")
  end
  
  it "fails if no input file is supplied" do
    @nugetupdate.extend(FailPatch)
    @nugetupdate.get_command_parameters
    @strio.string.should include("An input file must be specified")
  end
end