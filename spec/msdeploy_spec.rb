require 'spec_helper'
require 'albacore/msdeploy'

describe MSDeploy, "Deploying a package without specifying anything" do
  before :each do
    @msdeploy = MSDeploy.new
    @msdeploy.extend(SystemPatch)
  end
  
  it "Should raise excecption as package is not in the CWD" do
    lambda {@msdeploy.execute}.should raise_error(RuntimeError ,"Could not find the MSDeploy package to deploy.")
  end
end

describe MSDeploy, "Deploying a package from a folder" do
  
  before :each do
    @msdeploy = MSDeploy.new
    @msdeploy.deploy_package = "spec\\support\\TestSolution\\TestSolution.MSDeploy\\TestSolution.MSDeploy\\obj\\Release\\Package"
    @msdeploy.noop = true
    @msdeploy.extend(SystemPatch)
  end
  
  it "should deploy locally" do
    lambda {@msdeploy.execute}.should_not raise_error(RuntimeError ,"MSDeploy Failed.  See build log for details")  
    @msdeploy.system_command.scan(/-whatif/).length.should be(1)
  end
  
  it "with username, password and server, should fail as that is not a valid username/password or server" do
    @msdeploy.username = "testname"
    @msdeploy.password = "testpasssword"
    @msdeploy.server = "testserver"
    #assert
    lambda {@msdeploy.execute}.should raise_error(RuntimeError ,"MSDeploy Failed.  See build log for details")
    @msdeploy.system_command.scan(/computerName='testserver',userName='testname',password='testpasssword'/).length.should be(1)
    end
end

describe MSDeploy, "Deploying a package from a folder with a zip" do
  before :each do
    @msdeploy = MSDeploy.new
    @msdeploy.extend(SystemPatch)
    @msdeploy.noop = true
    @msdeploy.deploy_package = "spec/support/TestSolution/TestSolution.MSDeploy/TestSolution.MSDeploy/obj/Debug/Package"
  end
  
   it "should deploy locally" do
    lambda {@msdeploy.execute}.should_not raise_error(RuntimeError ,"MSDeploy Failed.  See build log for details")      
    @msdeploy.system_command.scan(/-whatif/).length.should be(1)    
    @msdeploy.system_command.scan(/TestSolution.MSDeploy.zip/).length.should be(1)
  end
  
  it "with username, password and server, should fail as that is not a valid username/password or server" do
    @msdeploy.username = "testname"
    @msdeploy.password = "testpasssword"
    @msdeploy.server = "testserver"
    #assert
    lambda {@msdeploy.execute}.should raise_error(RuntimeError ,"MSDeploy Failed.  See build log for details")
    @msdeploy.system_command.scan(/computerName='testserver',userName='testname',password='testpasssword'/).length.should be(1)
  end
    
    it "with aditional parameters" do
    @msdeploy.additional_parameters = "-usechecksum"
    lambda {@msdeploy.execute}.should_not raise_error(RuntimeError ,"MSDeploy Failed.  See build log for details")  
    @msdeploy.system_command.scan(/-usechecksum/).length.should be(1)   
  end
  
  it "with specifying a parameter file" do
    @msdeploy.parameters_file = "spec/support/TestSolution/TestSolution.MSDeploy/TestSolution.MSDeploy/obj/Debug/Package/TestSolution.MSDeploy.SetParameters.xml"
    lambda {@msdeploy.execute}.should_not raise_error(RuntimeError ,"MSDeploy Failed.  See build log for details")  
    @msdeploy.system_command.scan(/-setParamFile:/).length.should be(1)
    @msdeploy.system_command.scan(/TestSolution.MSDeploy.SetParameters.xml/).length.should be(1)
  end  
  
  it "With specifying a bad parameter file, will throw an exception" do
      @msdeploy.parameters_file = "spec/support/TestSolution/TestSolution.MSDeploy/TestSolution.MSDeploy/TestSolution.MSDeploy.SetParameters.xml"
    lambda {@msdeploy.execute}.should raise_error(RuntimeError ,"Could not find parameter file specified.")      
  end
end


describe MSDeploy, "Deploying a package from a zip file" do
  before :each do
    @msdeploy = MSDeploy.new
    @msdeploy.extend(SystemPatch)
    @msdeploy.noop = true
    @msdeploy.deploy_package = "spec/support/TestSolution/TestSolution.MSDeploy/TestSolution.MSDeploy/obj/Debug/Package/TestSolution.MSDeploy.zip"
  end
  
  it "should deploy locally" do
    lambda {@msdeploy.execute}.should_not raise_error(RuntimeError ,"MSDeploy Failed.  See build log for details")  
    p @msdeploy.deploy_package
    p @msdeploy.system_command
    @msdeploy.system_command.scan(/-whatif/).length.should be(1)    
    @msdeploy.system_command.scan(/TestSolution.MSDeploy.zip/).length.should be(1)
  end
  
  it "with username, password and server, should fail as that is not a valid username/password or server" do
    @msdeploy.username = "testname"
    @msdeploy.password = "testpasssword"
    @msdeploy.server = "testserver"
    #assert
    lambda {@msdeploy.execute}.should raise_error(RuntimeError ,"MSDeploy Failed.  See build log for details")
    @msdeploy.system_command.scan(/computerName='testserver',userName='testname',password='testpasssword'/).length.should be(1)
  end
    
  it "with aditional parameters" do
    @msdeploy.additional_parameters = "-usechecksum"
    lambda {@msdeploy.execute}.should_not raise_error(RuntimeError ,"MSDeploy Failed.  See build log for details")  
    @msdeploy.system_command.scan(/-usechecksum/).length.should be(1)   
  end
  
  it "with specifying a parameter file" do
    @msdeploy.parameters_file = "spec/support/TestSolution/TestSolution.MSDeploy/TestSolution.MSDeploy/obj/Debug/Package/TestSolution.MSDeploy.SetParameters.xml"
    lambda {@msdeploy.execute}.should_not raise_error(RuntimeError ,"MSDeploy Failed.  See build log for details")  
    @msdeploy.system_command.scan(/-setParamFile:/).length.should be(1)
    @msdeploy.system_command.scan(/TestSolution.MSDeploy.SetParameters.xml/).length.should be(1)
  end  
  
  it "With specifying a bad parameter file, will throw an exception" do
      @msdeploy.parameters_file = "spec/support/TestSolution/TestSolution.MSDeploy/TestSolution.MSDeploy/TestSolution.MSDeploy.SetParameters.xml"
    lambda {@msdeploy.execute}.should raise_error(RuntimeError ,"Could not find parameter file specified.")      
  end
end