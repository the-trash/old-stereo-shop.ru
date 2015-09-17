@javascript
Feature: As a user I want to leave review
  Background:
    Given a product exists
    When I go to the product's page
    And I click on review's tab
    Then I should see add new review button
    When I click on new review button
    Then I should see new review form

  Scenario: I go to the product page and leave review
    When I fill pluses input by "pluses"
    And I fill cons input by "cons"
    And I fill body input by "body"
    And I set rating on "4"
    And I send review on moderation
    Then I should see success message

  Scenario: I go to the product page and leave review but then reject
    When I click on reject button
    Then I should see add new review button
    And I should not see new review form
