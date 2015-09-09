describe MakeOrderInOneClickForm do
  let!(:product) { create :product }

  subject { described_class.new(current_user, params).save }

  shared_examples_for 'should right data change' do
    specify { expect{ subject }.to change{ Order.count }.by(1) }
    specify { expect{ subject }.to change{ Cart.count }.by(1) }
    specify { expect{ subject }.to change{ LineItem.count }.by(1) }
  end

  shared_examples_for 'generate correct data' do
    it_behaves_like 'should right data change'

    it "line item's cart should equal generated cart" do
      subject
      expect(LineItem.first.cart).to eq(Cart.first)
    end

    it "order's line items should contain generated line item" do
      subject
      expect(Order.first.line_items).to include LineItem.first
    end

    it 'has relation with correct product' do
      subject
      expect(LineItem.first.product).to eq product
    end
  end

  shared_examples_for 'order should not be generated' do |orders_count, line_items_count, carts_count|
    specify { expect{ subject }.not_to change{ Order.count } }
    specify { expect{ subject }.not_to change{ LineItem.count } }
    specify { expect{ subject }.not_to change{ Cart.count } }
  end

  context 'when user exists' do
    let(:current_user) { create :user }
    let(:params) { { product_id: product.id, phone: '123' } }

    it_behaves_like 'generate correct data'
  end

  context "when user doesn't exists" do
    let(:current_user) { nil }
    let(:params) { { product_id: product.id, phone: '123' } }

    it_behaves_like 'generate correct data'
  end

  context "when params doesn't correct" do
    let(:current_user) { create :user }
    let(:params) { {} }

    specify { expect(subject).to be_falsy }
    it_behaves_like 'order should not be generated'
  end

  context 'when user has order with the same params' do
    let(:current_user) { create :user }
    let(:cart) { create :cart, user: current_user }
    let(:line_item) { create :line_item, product: product, cart: cart }
    let!(:order) { create :order, :with_line_items, line_item: line_item, user: current_user, phone: '123', cart: cart }
    let(:params) { { product_id: product.id, phone: '123' } }

    it_behaves_like 'order should not be generated'

    context 'when user is trying to make order for another product' do
      let!(:another_product) { create :product }
      let(:params) { { product_id: another_product.id, phone: '123' } }

      it_behaves_like 'should right data change'
    end
  end
end
