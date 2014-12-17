require 'json'

class VkLocation::StereoShopLocation
  cattr_accessor :responser

  def initialize(responser)
    @responser = responser
  end

  def data(method, params = {})
    @responser.get_response(method, params)

    JSON.parse(@responser.body)['response']['items']
  end
end
