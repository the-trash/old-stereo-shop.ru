class Recurring::CentralBankUpdateAttitudeEuroByRub
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: 5, unique: true

  recurrence { hourly(6) }

  def perform
    cb = CentralBankExchangeRates.new
    eur_value = cb.current_euro_rate

    Product.published.with_euro_price.find_each do |product|
      product.update_columns({ price: product.euro_price * eur_value, euro_rate: eur_value})
    end if eur_value.nonzero?
  end
end
