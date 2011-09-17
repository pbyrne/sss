Feature: SSS displays help

  As a user
  I want to dislay help

  Scenario: with no parameter
    When I run `sss`
    Then the help text displays
    And the exit status should be 0

  Scenario: with the --help parameter
    When I run `sss --help`
    Then the help text displays
    And the exit status should be 0

  Scenario: with the help parameter
    When I run `sss help`
    Then the help text displays
    And the exit status should be 0

  Scenario: with an invalid parameter
    When I run `sss asdfabeabeb`
    Then the help text displays
    And the exit status should be 0

