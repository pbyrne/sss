require 'spec_helper'

describe SSS, "::HELP" do
  it "should have help" do
    SSS::HELP
  end
end

describe SSS, ".initialize(command)" do
  it "should retain the supplied command" do
    SSS.new("asdf").command.should == "asdf"
  end

  it "should default the workspace to ~/workspace/" do
    SSS.new.workspace.should == "~/workspace/"
  end

  it "should use the WORKSPACE environment variable, if present" do
    # capture existing workspace to return afterward
    orig_workspace = ENV['WORKSPACE']

    ENV['WORKSPACE'] = "/tmp/asdf/"
    SSS.new.workspace.should == "/tmp/asdf/"

    ENV['WORKSPACE'] = orig_workspace
  end
end

describe SSS, ".run(command)" do
  let!(:sss) { SSS.new }

  it "should instantiate and run the command" do
    SSS.should_receive(:new).with("asdf").and_return(sss)
    sss.should_receive(:run)
    SSS.run("asdf")
  end
end

describe SSS, "#run" do
  let (:sss) { SSS.new }

  it "should run the command and return true if it is in the list of commands" do
    command = SSS::COMMANDS.first
    sss.stub(:directories => ["dir1", "dir2"])
    sss.should_receive(:perform).with(command, "dir1")
    sss.should_receive(:perform).with(command, "dir2")
    sss.command = command

    sss.run.should be_true
  end

  it "should return false if the command is not on the list" do
    sss.command = "asdfaebaeba"
    sss.run.should be_false
  end
end

describe SSS, "#directories" do
  let (:sss) { SSS.new }

  it "should return the list of directories from the workspace" do
    # spec/lib/support/workspace/
    sss.workspace = File.join(File.dirname(__FILE__), '../support/workspace/')
    sss.directories.should == Dir["#{sss.workspace}/*"].map { |dir| File.expand_path(dir) }
  end

  it "should raise an error if the workspace does not exist" do
    # non-existant spec/lib/support/noworkspace/
    sss.workspace = File.join(File.dirname(__FILE__), '../support/noworkspace/')
    expect { sss.directories }.to raise_error
  end
end

describe SSS, "#display_command" do
  it "should output that it's performing the command" do
    subject.command = "asdf"
    subject.display_command.should == "Attempting to perform asdf"
  end
end
