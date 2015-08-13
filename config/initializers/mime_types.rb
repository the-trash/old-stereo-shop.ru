# fix bug precompile files with .map extention
 # https://github.com/emberjs/ember-rails/issues/428#issuecomment-75125279
 Rack::Mime::MIME_TYPES.merge!({ '.map' => 'text/plain' })
