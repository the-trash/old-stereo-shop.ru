Sidekiq.configure_server do |config|
  config.redis = {
    url: 'redis://localhost:6400/',
    namespace: "stereo_shop_#{ENV['RAILS_ENV']}"
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: 'redis://localhost:6400/',
    namespace: "stereo_shop_#{ENV['RAILS_ENV']}"
  }
end
