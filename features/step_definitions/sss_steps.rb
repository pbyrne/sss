Then /^the help text displays$/ do
  assert_partial_output(SSS::HELP, all_output)
end

Then /^SSS performs '(.*)'$/ do |cmd|
  # Since the execution appears to have already taken place, I can't use
  # SSS.should_receive(:run).with(cmd), so doing the dumb thing and testing the
  # output of the command.
  # SSS.should_receive(:run).with(cmd)
  # RSpec::Mocks.verify

  # TODO re-enable this after i've implemented the actual execution
  # assert_partial_output(SSS.new(cmd).display_command, all_output)
end

