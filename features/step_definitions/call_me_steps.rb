When(/^click on call me button$/) do
  find('.b-call-me-button').click
end

Then(/^I should see dialog with phone's input$/) do
  within '.l-call-me-modal-content' do
    expect(page).to have_css '.b-call-me-phone-input'
  end
end
