# Run rake tmp:cache:clear to flush asset pipeline cache after changing this configuration
JsRoutes.setup do |config|
  config.include = [
    /^call_me_feedbacks$/
  ]
end
