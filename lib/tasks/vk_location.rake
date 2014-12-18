namespace :vk_location do
  require 'ruby-progressbar'

  progressbar =
    ProgressBar.create({
      total: nil,
      format: '%t %B %p%% %e'
    })

  desc 'Fetch Regions'
  task fetch_regions: :environment do
    progressbar.title = 'Fetch Regions'

    # puts VkLocation::ApiVkRequestLocation.new
  end
end
