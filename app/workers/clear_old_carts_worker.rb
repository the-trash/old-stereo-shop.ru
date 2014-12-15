class ClearOldCartsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: 5, unique: true

  recurrence { weekly }

  def perform
    Cart.old_cart.destroy_all
    LineItem.broken_position.destroy_all
  end
end
