class YandexMarketExportDecorator < Draper::Decorator
  delegate_all

  def text_format_temp_body
    [].tap do |temp_body|
      temp_body << id
      temp_body << Settings.yandex_market.text_format.type_name
      temp_body << in_stock
      temp_body << product_url
      temp_body << filtered_price
      temp_body << Settings.yandex_market.text_format.currency_id
      temp_body << product_category_title
      temp_body << picture_url
      temp_body << brand_title
      temp_body << title
      temp_body << filtered_description
    end
  end

  private

  def filtered_price
    price_with_discount < 0 ? 0 : price_with_discount
  end

  def picture_url
    h.image_url photos.default.file.url if photos.any?
  end

  def filtered_description letters_count = Settings.yandex_market.text_format.letters_count
    truncated_description(letters_count).gsub /\r\n|\r|\n|\t/, ' '
  end

  def product_url
    h.product_url model, Rails.application.config.action_mailer.default_url_options
  end

  def truncated_description letters_count
    h.truncate Sanitize.fragment(description), length: letters_count
  end
end
