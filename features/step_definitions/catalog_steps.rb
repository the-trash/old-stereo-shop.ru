When(/^click on catalog button$/) do
  find("#catalog").click
end

Then(/^I should see dropdown menu in catalog$/) do
  within "#catalog" do
    expect(page).to have_css '.btn-group.open'
  end
end

Then(/^I should see in menu item with #{capture_model}$/) do |category|
  within "#catalog" do
    expect(page).to have_content model!(category).title
  end
end

Then(/^I should see in submenu item with #{capture_model}$/) do |category|
  expect(find('.dropdown-submenu')).to have_content model!(category).title
end

When(/^I click on categories link$/) do
  find(".categories-list a.b-link-with-child").click
end

Then(/^I should see opened menu$/) do
  expect(find('.categories-list')).to have_css '.with-children.open'
end

Then(/^I should see link with #{capture_model} name$/) do |category|
  expect(find('.categories-list .b-link-with-child')).to have_content model!(category).title
end

Then(/^I should see in submenu item with #{capture_model} name$/) do |category|
  expect(find('.categories-list .dropdown-menu')).to have_content model!(category).title
end
