Feature: A user sees meta data on an every page
  
  Scenario: Visit a brands index page and see meta tags
    Given a seo_setting exists with seo_title: "The best brands", seo_description: "index page", keywords: "brands, index, meta"
    When I visit a brands index page
    Then I should see title with text "The best brands"
    And I should see meta tag with content "index page"
    And I should see meta tag with content "brands, index, meta"

  Scenario: Visit a home page and see meta tags from I18n
    When I go to the home page
    Then I should see title with text "meta_tags.welcome.index.title" as argument of method I18n
    And I should see meta tag with content "meta_tags.welcome.index.description" as argument of method I18n
    And I should see meta tag with content "meta_tags.welcome.index.keywords" as argument of method I18n
