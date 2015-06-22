describe Recurring::CentralBankUpdateAttitudeEuroByRub do
  let!(:product_with_euro_price) { create :product }
  let!(:product_without_euro_price) { create :product, euro_price: 0 }
  let!(:draft_product) { create :product, :draft }
  let(:euro_rate) { CentralBankExchangeRates.new.current_euro_rate }

  subject { described_class.new.perform }

  specify { expect{ subject }.to change{ product_with_euro_price.reload.euro_rate }.to(euro_rate) }
  specify { expect{ subject }.to change{ product_with_euro_price.reload.price }.to((product_with_euro_price.euro_price * euro_rate).round) }

  specify { expect{ subject }.not_to change{ product_without_euro_price.reload.euro_rate } }
  specify { expect{ subject }.not_to change{ product_without_euro_price.reload.price } }

  specify { expect{ subject }.not_to change{ draft_product.reload.euro_rate } }
  specify { expect{ subject }.not_to change{ draft_product.reload.price } }
end
