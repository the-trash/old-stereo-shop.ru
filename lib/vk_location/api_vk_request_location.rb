require 'net/http'

class VkLocation::ApiVkRequestLocation
  cattr_accessor :api_v, :count, :url, :response

  def initialize(url = 'http://api.vk.com/method/', api_v = '5.27', count = 1000)
    @url, @api_v, @count = url, api_v, count
  end

  def get_response(method, params = {})
    uri = URI("#{ @url }database.#{ method }")

    params.merge!({
      v: @api_v,
      count: @count
    })

    uri.query = URI.encode_www_form(params)

    @response = Net::HTTP.get_response(uri)
    @response
  end

  def body
    @response.body
  end

  def head_code
    @response.code
  end

  def head_message
    @response.message
  end
end
