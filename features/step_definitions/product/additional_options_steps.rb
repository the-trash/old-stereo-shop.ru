Then(/^I (should|should not) see #{capture_model}$/) do |verb, option_model|
  additional_option = model!(option_model)
  within '.l-product-additional-options' do
    if verb == 'should'
      expect(page).to have_content additional_option.title
    else
      expect(page).not_to have_content additional_option.title
    end
  end
end

Then(/^the select (should|should not) contain #{capture_model}$/) do |verb, option|
  option_value = model!(option)
  within '.l-product-additional-options' do
    values = find('.b-additional-option-select').all('option').map(&:text)
    if verb == 'should'
      expect(values).to include option_value.value
    else
      expect(values).not_to include option_value.value
    end
  end
end

Then(/^I (should|should not) see for choose #{capture_model}$/) do |verb, option|
  option_value = model!(option)
  within '.l-product-additional-options' do
    if verb == 'should'
      expect(page).to have_content option_value.value
    else
      expect(page).not_to have_content option_value.value
    end
  end
end

Then(/^I should not see additional options$/) do
  expect(page).not_to have_css '.l-additional-options'
end
