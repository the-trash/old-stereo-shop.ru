# TODO add test for changing product attributes
@javascript
Feature: As a user I want to choose options for product
  Scenario: I go to the product page and choose between options into select
    Given a product exists
    And a option like select style "Cool select" exists with product: the product, title: "Cool select"
    And a option like select style "Cool select draft" exists with product: the product, title: "Cool select draft", state: "draft"
    And a additional options value "Published value" exists with additional_option: the option like select style "Cool select", value: "Published value"
    And a additional options value "Draft value" exists with additional_option: the option like select style "Cool select", state: "draft", value: "Draft value"
    When I go to the product's page
    Then I should see the option like select style "Cool select"
    And I should not see the option like select style "Cool select draft"
    And the select should contain the additional options value "Published value"
    And the select should not contain the additional options value "Draft value"

  Scenario: I go to the product page and choose between options into radio type additional option
    Given a product exists
    And a option like radio type "Cool radio" exists with product: the product, title: "Cool radio"
    And a option like radio type "Cool radio draft" exists with product: the product, title: "Cool radio draft", state: "draft"
    And a additional options value "Published value" exists with additional_option: the option like radio type "Cool radio", value: "Published value"
    And a additional options value "Draft value" exists with additional_option: the option like radio type "Cool radio", state: "draft", value: "Draft value"
    When I go to the product's page
    Then I should see the option like radio type "Cool radio"
    And I should not see the option like radio type "Cool radio draft"
    And I should see for choose the additional options value "Published value"
    And I should not see for choose the additional options value "Draft value"

  Scenario: I go to the product page without additional options
    Given a product exists
    When I go to the product's page
    Then I should not see additional options
