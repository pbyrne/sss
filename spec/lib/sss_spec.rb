require 'spec_helper'

describe SSS, "having constants" do
  it "should have help" do
    SSS::HELP
  end

  context "for the supported SCMs" do
    it "should have git" do
      SSS::GIT
    end

    it "should have mercurial" do
      SSS::MERCURIAL
    end

    it "should have subversion" do
      SSS::SUBVERSION
    end
  end
end

describe SSS, ".initialize(command)" do
  it "should retain the supplied command" do
    SSS.new("asdf").command.should == "asdf"
  end

  it "should default the workspace to ~/workspace/" do
    SSS.new.workspace.should == "~/workspace/"
  end

  it "should use the SSS_WORKSPACE environment variable, if present" do
    # capture existing workspace to return afterward
    orig_workspace = ENV['SSS_WORKSPACE']

    ENV['SSS_WORKSPACE'] = "/tmp/asdf/"
    SSS.new.workspace.should == "/tmp/asdf/"

    ENV['SSS_WORKSPACE'] = orig_workspace
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
  it "should run the command and return true if it is in the list of commands" do
    subject.stub(:directories => ["dir1", "dir2"])
    subject.should_receive(:perform_command).with("dir1")
    subject.should_receive(:perform_command).with("dir2")
    subject.command = "pull"

    subject.run.should be_true
  end

  it "should return false if the command is not on the list" do
    subject.command = "asdfaebaeba"
    subject.run.should be_false
  end
end

describe SSS, "#directories" do
  it "should return the list of directories from the workspace" do
    # spec/lib/support/workspace/
    subject.workspace = File.join(File.dirname(__FILE__), '../support/workspace/')
    subject.directories.should == Dir["#{subject.workspace}/*"].map { |dir| File.expand_path(dir) }
  end

  it "should raise an error if the workspace does not exist" do
    # non-existant spec/lib/support/noworkspace/
    subject.workspace = File.join(File.dirname(__FILE__), '../support/noworkspace/')
    expect { subject.directories }.to raise_error
  end
end

describe SSS, "#perform_command(directory)" do
  subject { SSS.new("pull") }
  let (:directory) { "/tmp/directory/" }

  it "performs the appropriate SCM command for the directory" do
    # subject.expects(:scm_for).with(directory).returns(SSS::GIT)
    subject.should_receive(:scm_command_for).with(directory).and_return("asdf command")
    Open3.should_receive(:capture3).with("asdf command")
    subject.perform_command(directory)
  end
end

describe SSS, "#scm_command_for(directory)" do
  subject { SSS.new("pull") }
  let (:directory) { "/tmp/directory/"}

  it "should return the command for the SCM of the directory" do
    subject.should_receive(:scm_for).with(directory).and_return(SSS::GIT)
    subject.scm_command_for(directory).should == SSS::COMMANDS[subject.command][SSS::GIT]
  end

  it "should return nil if it does not recognize the SCM for the directory" do
    subject.should_receive(:scm_for).with(directory).and_return(nil)
    subject.scm_command_for(directory).should be_nil
  end

  it "should return nil if it does not recognize the command" do
    subject.command = "asdfqwerty"
    subject.scm_command_for(directory).should be_nil
  end
end

describe SSS, "#display_command" do
  it "should output that it's performing the command" do
    subject.command = "asdf"
    subject.display_command.should == "Attempting to perform asdf"
  end
end
