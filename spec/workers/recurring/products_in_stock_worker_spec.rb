describe Recurring::ProductsInStockWorker do
  let!(:product_in_stores) { create :product, :with_stores }
  let!(:product_in_stores_with_false_instock) { create :product, :with_stores, in_stock: false }
  let!(:product) { create :product }

  subject { described_class.new.perform }

  specify { expect{ subject }.to change{ product.reload.in_stock }.from(true).to(false) }
  specify { expect{ subject }.to change{ product_in_stores_with_false_instock.reload.in_stock }.from(false).to(true) }
  specify { expect{ subject }.not_to change{ product_in_stores.reload.in_stock } }
end
