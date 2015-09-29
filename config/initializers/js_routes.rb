# Run rake tmp:cache:clear to flush asset pipeline cache after changing this configuration
JsRoutes.setup do |config|
  config.include = [
    /^call_me_feedbacks$/,
    /^in_one_click_orders$/,
    /^product_additional_option$/,
    /^product$/,
    /^review(s)?$/
  ]
end
