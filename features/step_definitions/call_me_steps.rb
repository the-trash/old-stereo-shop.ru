When(/^click on call me button$/) do
  find('.b-call-me-button').click
end

Then(/^I should see dialog with phone's input$/) do
  within '.l-call-me-modal-content' do
    expect(page).to have_css '.b-call-me-phone-input'
  end
end

When(/^I click on send phone button$/) do
  within '.l-call-me-from' do
    find('.b-call-me-send-btn').click
  end
end

Then(/^I should see error class on phone's input$/) do
  within '.l-call-me-from' do
    expect(page).to have_css '.has-error'
  end
end

When(/^I fill phone input with "(.*?)"$/) do |phone|
  within '.l-call-me-from' do
    find('.b-call-me-phone-input').set phone
  end
end

Then(/^I should see success user message$/) do
  within '.l-call-me-modal-content' do
    expect(page).to have_content I18n.t('call_me_success_message')
  end
end
