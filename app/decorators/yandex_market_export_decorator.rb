class YandexMarketExportDecorator < Draper::Decorator
  delegate_all

  def text_format_temp_body
    [].tap do |temp_body|
      temp_body << id
      temp_body << in_stock
      temp_body << product_url
      temp_body << price_with_discount
      temp_body << Settings.yandex_market.text_format.currency_id
      temp_body << product_category_title
      temp_body << picture_url
      temp_body << in_stock
      temp_body << in_stock
      temp_body << true
      temp_body << title
      temp_body << filtered_description
      temp_body << brand_title
    end
  end

  private

  def picture_url
    h.asset_url photos.default.file.url if photos.any?
  end

  def filtered_description letters_count = Settings.yandex_market.text_format.letters_count
    h.truncate Sanitize.fragment(description), length: letters_count
  end

  def product_url
    h.product_url model, Rails.application.config.action_mailer.default_url_options
  end
end