Then(/^I should see form to make order$/) do
  within '.l-make-order-in-one-click-body' do
    expect(page).to have_css '.b-make-order-in-one-click-form'
  end
end
