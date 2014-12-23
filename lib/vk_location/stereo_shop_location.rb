require 'json'

class VkLocation::StereoShopLocation
  cattr_accessor :responser, :response

  def initialize(responser)
    @responser = responser
  end

  def data(method, params = {})
    @responser.get_response(method, params)

    @response = JSON.parse(@responser.body, { symbolize_names: true })
    @response
  end

  def items
    errors_exists? ? [] : @response[:response][:items]
  end

  def errors_exists?
    @response[:error].present?
  end

  def fetch_regions(offset = 0, &block)
    method = 'getRegions'

    data(method, { offset: offset })

    if items.any?
      region_titles = Region.pluck(:title)

      region_for_create = items_for_create(region_titles, items)

      create_regions(region_for_create) do
        block.call if block_given?
      end if region_for_create.any?

      offset += 1

      sleep(0.2)

      fetch_regions(offset) do
        block.call if block_given?
      end
    end

    true
  end

  def fetch_cities(region_id, region_vk_id, offset = 0, &block)
    method = 'getCities'

    data(method, { offset: offset, region_id: region_vk_id })

    if items.any?
      city_titles = City.pluck(:title)

      cities_for_create = items_for_create(city_titles, items)

      create_cities(cities_for_create, region_id) do
        block.call if block_given?
      end if cities_for_create.any?

      offset += 1

      sleep(0.1)

      fetch_cities(region_id, region_vk_id, offset) do
        block.call if block_given?
      end
    end

    true
  end

  private

  def create_regions(regions, &block)
    regions.each do |region|
      title = region[:title].strip

      if Region.find_by(title: title).nil?
        Region.create!(title: title, vk_id: region[:id])

        block.call if block_given?
      end
    end
  end

  def create_cities(cities, region_id, &block)
    cities.each do |city|
      title = city[:title].strip

      if City.find_by(title: title).nil?
        City.create!(title: title, vk_id: city[:id], region_id: region_id)

        block.call if block_given?
      end
    end
  end

  def items_for_create titles, items
    items.reject { |item| titles.include?(item[:title]) }.uniq! { |item| item[:title] } || []
  end
end
