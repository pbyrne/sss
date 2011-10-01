require 'spec_helper'

describe SSS, "::HELP" do
  it "should have help" do
    SSS::HELP
  end
end

describe SSS, ".initialize(command)" do
  subject { SSS.new("asdf") }

  it "should retain the supplied command" do
    subject.command.should == "asdf"
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

describe SSS, "#display_command" do
  it "should output that it's performing the command" do
    subject.command = "asdf"
    subject.display_command.should == "Attempting to perform asdf"
  end
end
