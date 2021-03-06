describe Product::ImportEntry, type: :model do
  let(:import_entry) { create :product_import_entry }

  describe '#import!' do
    subject { import_entry.import! }

    specify {
      expect{ subject }.to change(Product, :count).from(0).to(1)
    }

    specify {
      expect{ subject }.to change(ProductsStore, :count).from(0).to(2)
    }

    context 'when new product' do
      let(:brand) { Brand.find_by(title: import_entry.brand) }

      before { import_entry.import! }

      subject { Product.find_by(title: import_entry.title) }

      %i(title description sku).each do |product_attribute|
        its(product_attribute) { import_entry.send(product_attribute) }
      end

      %i(price discount euro_price).each do |product_attribute|
        its(product_attribute) { import_entry.send(product_attribute).to_f }
      end

      its(:brand_id) { brand.id }
    end

    context 'when we update product' do
      let!(:product) { create :product }
      let(:import_entry_need_update) {
        create :product_import_entry, :need_update, title: product.title
      }

      before { import_entry.import! }

      subject { import_entry_need_update.import! }

      %i(description sku).each do |product_attribute|
        specify {
          expect{ subject }.to change{ product.reload.send(product_attribute) }
            .to(import_entry_need_update.send(product_attribute))
        }
      end

      %i(price discount euro_price).each do |product_attribute|
        specify {
          expect{ subject }.to change{ product.reload.send(product_attribute) }
            .to(import_entry_need_update.send(product_attribute).to_f)
        }
      end
    end
  end
end
