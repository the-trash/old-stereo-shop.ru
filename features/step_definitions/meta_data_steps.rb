When(/^I visit a brands index page$/) do
  visit "/brands"
end

Then(/I should see title with text "([^"]*)"(?: as argument of method (.*))?/) do |text, method|
  text = I18n.t(text) if method.present?
  expect(page).to have_css "title", text: text
end

Then(/I should see meta tag with content "([^"]*)"(?: as argument of method (.*))?/) do |content, method|
  content = I18n.t(content) if method.present?
  expect(page).to have_css "meta[content='#{content}']"
end
