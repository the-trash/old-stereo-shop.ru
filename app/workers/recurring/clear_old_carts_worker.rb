class Recurring::ClearOldCartsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: 5, unique: true

  recurrence { weekly }

  def perform
    Cart.old_cart.destroy_all
    LineItem.broken_position.destroy_all
    Order.where(user_id: nil, cart_id: nil).destroy_all
  end
end
