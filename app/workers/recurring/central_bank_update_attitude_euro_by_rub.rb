class Recurring::CentralBankUpdateAttitudeEuroByRub
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: 5, unique: true

  recurrence { hourly(6) }

  def perform
    date_now = Time.zone.now.to_date
    cb       = CentralBankExchangeRates.new

    response = cb.get_range_report(date_now, date_now, Settings.central_bank.currency_code.eur)

    eur_value = cb.range_report_by_node(response.body, 'Value').text().to_f

    Product.published.with_euro_price.find_each do |product|
      product.update_column(:price, product.euro_price * eur_value)
    end
  end
end
