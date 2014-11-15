Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV['REDISCLOUD_URL'] || 'redis://localhost/',
    namespace: "stereo_shop_#{ENV['RAILS_ENV']}"
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV['REDISCLOUD_URL'] || 'redis://localhost/',
    namespace: "stereo_shop_#{ENV['RAILS_ENV']}"
  }
end
