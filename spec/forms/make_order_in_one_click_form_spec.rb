describe MakeOrderInOneClickForm do
  let!(:product) { create :product }

  subject { described_class.new(current_user, params).save }

  shared_examples_for 'generate correct data' do
    specify { expect{ subject }.to change{ Order.count }.from(0).to(1) }
    specify { expect{ subject }.to change{ Cart.count }.from(0).to(1) }
    specify { expect{ subject }.to change{ LineItem.count }.from(0).to(1) }

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
  end
end
