@javascript
Feature: As a user I want to make order in one click
  # TODO add tests for authorized user
  Background:
    Given a product exists
    When I go to the product's page

  Scenario: I go to the product page and make order
    Then I should see form to make order
    When I click on send order's phone button
    Then I should see error class on order's phone input
    When I fill order's phone input with "test"
    And I click on send order's phone button
    Then I should see error class on order's phone input
    When I fill order's phone input with "123-123-1233"
    And I click on send order's phone button
    Then I should see order's success user message
