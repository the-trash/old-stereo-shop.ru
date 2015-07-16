class YandexMarketCsv
  def to_csv
    CSV.open temp_file.path, 'w' do |csv|
      csv << Settings.yandex_market.text_format.headers
      YandexMarketExportDecorator.decorate_collection(products).each do |product|
        csv << product.text_format_temp_body
      end
    end

    temp_file
  end

  def unlink
    temp_file.close
    temp_file.unlink
  end

  private

  def temp_file
    @temp_file ||= Tempfile.new [SecureRandom.uuid, '.csv']
  end

  def products
    Product.for_yandex_market.published
  end
end
