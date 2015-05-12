class Recurring::CentralBankUpdateAttitudeEuroByRub
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: 5, unique: true

  recurrence { hourly(6) }

  def perform
    cb = CentralBankExchangeRates.new

    response = cb.get_daily_report(Time.zone.now.to_date)
    eur_value = cb.report_by_currency(response.body, Settings.central_bank.currency_code.eur).to_f

    Product.published.with_euro_price.find_each do |product|
      product.update_columns({ price: product.euro_price * eur_value, euro_rate: eur_value}) if eur_value.nonzero?
    end
  end
end
