Then(/^I should see add new review button$/) do
  expect(page).to have_css '.b-new-review-btn'
end

When(/^I click on new review button$/) do
  within '.l-new-review' do
    find('.b-new-review-btn').click
    wait_for_ajax
  end
end

When(/^I click on review's tab$/) do
  find('.b-product-reviews-tab').click
end

Then(/^I (should|should not) see new review form$/) do |verb|
  within '.l-new-review-form' do
    if verb == 'should'
      expect(page).to have_css '.b-new-review-form'
    else
      expect(page).not_to have_css '.b-new-review-form'
    end
  end
end

When(/^I fill (pluses|cons|body) input by "(.*?)"$/) do |input, text|
  within '.l-new-review-form' do
    find(".b-new-review-form-#{input}-input").set text
  end
end

When(/^I set rating on "(.*?)"$/) do |score|
  within '.l-new-review-form .b-ratable' do
    find("img[alt='#{score}']").click

    score_input = find("input[name='score']")
    expect(score_input.value).to eq score
  end
end

When(/^I send review on moderation$/) do
  within '.l-new-review-form' do
    find('.b-new-review-from-submit-btn').click
    wait_for_ajax
  end
end

Then(/^I should see success message$/) do
  within '.l-new-review-success-message' do
    expect(page).to have_css '.b-new-review-success-message'
  end
end

When(/^I click on reject button$/) do
  within '.l-new-review-form' do
    find('.b-new-review-from-cancel-btn.btn').click
  end
end
