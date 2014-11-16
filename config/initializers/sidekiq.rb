Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://localhost:#{ Settings.redis.port }/0",
    namespace: "stereo_shop_#{ENV['RAILS_ENV']}"
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://localhost:#{ Settings.redis.port }/0",
    namespace: "stereo_shop_#{ENV['RAILS_ENV']}"
  }
end
