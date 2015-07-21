class Recurring::CentralBankUpdateAttitudeEuroByRub
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: 5, unique: true

  recurrence { hourly(6) }

  def perform
    cb = CentralBankExchangeRates.new
    eur_value = cb.current_euro_rate

    Product.published.with_euro_price.without_fix_price.find_each do |product|
      price = (product.euro_price * eur_value).round
      product.update_columns({ price: price, euro_rate: eur_value})
    end if eur_value.nonzero?
  end
end
