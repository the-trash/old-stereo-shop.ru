Then(/^I should see form to make order$/) do
  within '.l-make-order-in-one-click-body' do
    expect(page).to have_css '.b-make-order-in-one-click-form'
  end
end

When(/^I click on send order's phone button$/) do
  find('.b-make-order-in-one-click-send-btn').click
  wait_for_ajax
end

When(/^I fill order's phone input with "(.*?)"$/) do |phone|
  within '.b-make-order-in-one-click-form' do
    find('.b-make-order-in-one-click-phone-input').set phone
  end
end

Then(/^I should see error class on order's phone input$/) do
  within '.l-make-order-in-one-click-body' do
    expect(page).to have_css '.has-error'
  end
end

Then(/^I should see order's success user message$/) do
  within '.l-make-order-in-one-click-body' do
    expect(page).to have_content I18n.t('call_me_success_message')
  end
end
