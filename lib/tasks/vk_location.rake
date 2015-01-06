namespace :vk_location do
  require 'ruby-progressbar'

  desc 'Fetch location from VK'
  task fetch_location: :environment do
    Rake::Task['vk_location:fetch_regions'].invoke
    Rake::Task['vk_location:fetch_cities'].invoke
  end

  desc 'Fetch Regions'
  task fetch_regions: :environment do
    progressbar = ProgressBar.create({
      total: nil,
      title: 'Fetch Regions',
      format: '%t %B count %c'
    })

    vk_location = VkLocation::ApiVkRequestLocation.new
    fetcher     = VkLocation::StereoShopLocation.new(vk_location)

    fetcher.fetch_regions do
      progressbar.increment
    end
  end

  desc 'Fetch Cities'
  task fetch_cities: :environment do
    progressbar = ProgressBar.create({
      total: nil,
      title: 'Fetch Cities',
      format: '%t %B count %c'
    })

    vk_location = VkLocation::ApiVkRequestLocation.new
    fetcher     = VkLocation::StereoShopLocation.new(vk_location)

    Region.find_each do |region|
      fetcher.fetch_cities(region.id, region.vk_id) do
        progressbar.increment
      end
    end
  end
end
