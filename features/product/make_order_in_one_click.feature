@javascript
Feature: As a user I want to make order in one click
  Background:
    Given a product exists
    When I go to the product's page

  Scenario: I go to the product page and make order
    Then I should see form to make order
