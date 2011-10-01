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
    subject.should_receive(:display).with("Performing #{subject.command} in #{subject.directory_string(directory)}")
    Open3.should_receive(:capture3).with("asdf command").and_return(["stdout", "stderr", "status"])
    subject.should_receive(:display).with("stdout")
    subject.should_receive(:display).with("stderr", STDERR)

    subject.perform_command(directory)
  end

  it "should skip the directory if it has no available command" do
    subject.should_receive(:scm_command_for).with(directory).and_return(nil)
    subject.should_receive(:display).with("Skipping #{subject.directory_string(directory)}, no available command")
    Open3.should_receive(:capture3).never

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

describe SSS, "#scm_for(directory)" do
  let(:workspace) { File.join(File.dirname(__FILE__), '../support/workspace/') }

  it "should return Git if the directory contains a .git directory" do
    subject.scm_for(File.join(workspace, "project1")).should == SSS::GIT
  end

  it "should return Mercurial if the directory contains a .hg directory" do
    subject.scm_for(File.join(workspace, "project2")).should == SSS::MERCURIAL
  end

  it "should return Subversion if the directory contains a .svn directory" do
    subject.scm_for(File.join(workspace, "project3")).should == SSS::SUBVERSION
  end
end

describe SSS, "#display" do
  it "should push to STDOUT" do
    STDOUT.should_receive(:puts).with("asdf")
    subject.display("asdf")
  end

  it "should push to STDERR if specified" do
    STDERR.should_receive(:puts).with("qwerty")
    subject.display("qwerty", STDERR)
  end
end

describe SSS, "#embolden(string)" do
  it "should wrap in bash bold characters" do
    subject.embolden("asdf").should == "\033[1masdf\033[0m"
  end
end

describe SSS, "#directory_string(directory)" do
  it "should embolden and trim just the last directory of the directory path with a slash" do
    subject.directory_string("/asdf/qwerty/aeiou/").should == subject.embolden("aeiou")
  end

  it "should embolden and trim just the last directory of the directory path without a slash" do
    subject.directory_string("/asdf/qwerty/aeiou").should == subject.embolden("aeiou")
  end
end

describe SSS, "#display_command" do
  it "should output that it's performing the command" do
    subject.command = "asdf"
    subject.display_command.should == "Attempting to perform asdf"
  end
end
