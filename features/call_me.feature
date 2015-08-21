@javascript
Feature: As an user I want to send message with request call me back

  Scenario: Click on call me button and send request
    When I go to the home page
    And click on call me button
    Then I should see dialog with phone's input
