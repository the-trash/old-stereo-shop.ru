$settings =
  if defined?(Setting) == 'constant'
    Setting.make_hash
  else
    nil
  end
