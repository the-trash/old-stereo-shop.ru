describe Cart do
  let!(:product) { create :product }

  describe '#add_product' do
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
end
