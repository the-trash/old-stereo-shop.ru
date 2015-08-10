describe Cart do
  describe '#add_product' do
    let!(:product) { create :product }
    subject { cart.add_product(product.id) }

    context 'cart without products' do
      let!(:cart) { create :cart }

      specify {
        expect { subject }.to change { cart.line_items.size }.from(0).to(1)
      }
    end

    context 'cart has products' do
      let!(:cart) { create :cart, :with_products }

      specify {
        expect { subject }.to change { cart.line_items.size }.from(3).to(4)
      }

      context 'cart already has product' do
        before { subject.save }

        specify {
          expect { cart.add_product(product.id) }.not_to change { cart.line_items.size }
        }

        specify {
          expect { cart.add_product(product.id) }.to change { subject.reload.quantity }.from(1).to(2)
        }
      end
    end
  end

  describe '.without_orders' do
    let!(:cart) { create :cart, :with_order }
    let!(:broken_cart) { create :cart, :broken_relation_with_order }

    subject { described_class.without_orders }

    specify { is_expected.to include broken_cart }
    specify { is_expected.not_to include cart }
  end

  describe '.old_carts' do
    let!(:cart) { create :cart }
    let!(:old_cart) { create :cart, :old_cart }

    subject { described_class.old_carts }

    specify { is_expected.to include old_cart }
    specify { is_expected.not_to include cart }
  end
end
