@javascript
Feature: As an user I want to send message with request call me back

  Scenario: Click on call me button and send request
    When I go to the home page
    And click on call me button
    Then I should see dialog with phone's input
    When I click on send phone button
    Then I should see error class on phone's input
    When I fill phone input with "test"
    Then I should see error class on phone's input
    When I fill phone input with "+7 (123) 123-1233"
    And I click on send phone button
    Then I should see success user message
