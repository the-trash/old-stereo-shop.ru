class Recurring::SitemapGeneratorWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: 5, unique: true

  recurrence { weekly }

  def perform
    system 'rake -s sitemap:refresh'
  end
end
