Feature: SSS performs the supplied command

  As a user
  I want to perform an SCM command

  Scenario: with a parameter
    When I run `sss up`
    Then SSS performs 'up'
    And the exit status should be 0

  Scenario: with another parameter
    When I run `sss st`
    Then SSS performs 'st'
    And the exit status should be 0

  Scenario: with multiple parameters
    When I run `sss foo bar`
    Then SSS performs 'foo'
    And the exit status should be 0
