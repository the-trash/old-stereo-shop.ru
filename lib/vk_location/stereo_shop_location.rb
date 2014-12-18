require 'json'
require 'activerecord-import'

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
    errors_exists? [] : @response[:response][:items]
  end

  def errors_exists?
    @response[:error].present?
  end

  def fetch_regions(offset = 0, &block)
    method = 'getRegions'

    data(method, { offset: offset, country_id: 1 })

    if items.any?
      create_regions(items) do
        block.call if block_given?
      end

      offset += 1
      data(method, { offset: offset, country_id: 1 })

      fetch_regions(offset) do
        block.call if block_given?
      end
    end

    true
  end

  def fetch_cities(region_id, offset = 0, &block)
    method = 'getCities'

    data(method, { offset: offset, region_id: region_id })

    if items.any?
      create_cities(items, region_id) do
        block.call if block_given?
      end

      offset += 1
      data(method, { offset: offset, region_id: region_id })

      fetch_cities(region_id, offset) do
        block.call if block_given?
      end
    end

    true
  end

  private

  def create_regions(regions, &block)
    new_regions =
      [].tap do |a|
        regions.each do |region|
          title  = region[:title].strip
          region = Region.find_by(title: title)
          a << Region.new(title: title, vk_id: region[:id]) if region
          block.call if block_given?
        end
      end

    Region.import(new_regions) if new_regions.any?
  end

  def create_cities(cities, region_id, &block)
    new_cities =
      [].tap do |a|
        cities.each do |city|
          title = city[:title].strip
          city  = City.find_by(title: title)
          a << City.new(title: title, vk_id: city[:id], region_id: region_id) if city
          block.call if block_given?
        end
      end

    City.import(new_cities) if new_cities.any?
  end
end
