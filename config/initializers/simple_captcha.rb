SimpleCaptcha.setup do |sc|
  sc.image_size  = '155x50'
  sc.image_style = 'stereo_shop_captcha'
  sc.add_image_style('stereo_shop_captcha',
    [
      "-background '#F4F7F8'",
      "-fill '#000'",
      "-border 1",
      "-bordercolor '#83636b'"
    ]
  )
end
