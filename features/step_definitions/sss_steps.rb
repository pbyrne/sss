Then /^the help text displays$/ do
  assert_partial_output(SSS::HELP, all_output)
end

Then /^SSS performs '(.*)'$/ do |cmd|
  # Since the execution appears to have already taken place, I can't use
  # SSS.should_receive(:run).with(cmd), so doing the dumb thing and testing the
  # output of the command.
  # SSS.should_receive(:run).with(cmd)
  # RSpec::Mocks.verify

  assert_partial_output(SSS.display_command(cmd), all_output)
end

