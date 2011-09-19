Then /^the help text displays$/ do
  assert_partial_output(SSS::HELP, all_output)
end

