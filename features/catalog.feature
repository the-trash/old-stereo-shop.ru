@javascript
Feature: As a user I want to see dropdown menu
  
  Background:
    Given product_category "Devices" exist with title: "Devices"
    And product_category "Headphones" exist with parent: product_category "Devices", title: "Headphones"
    And go to the home page

  Scenario: Click on catalog button and see dropdown menu
    When click on catalog button
    Then I should see dropdown menu in catalog
    And I should see in menu item with product_category "Devices"
    And I should see in submenu item with product_category "Headphones"

  Scenario: Click on menu item in categories list and see menu
    Then I should see link with product_category "Devices" name
    When I click on categories link
    Then I should see opened menu
    And I should see in submenu item with product_category "Headphones" name

