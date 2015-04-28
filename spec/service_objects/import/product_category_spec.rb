describe Import::ProductCategory do
  let(:product_category_title) { I18n.t('product_category_for_import') }
  let(:product_category) { create :product_category, title: product_category_title }
  let(:category_struct) { described_class.new }

  describe '#product_category' do
    subject { category_struct.product_category }

    context 'when product category exists' do
      before { product_category }

      specify { expect(subject).to eq(product_category) }
    end

    specify { expect(subject.title).to eq(product_category_title) }
  end

  describe '#params' do
    subject { category_struct.params }

    context 'when product category exists' do
      let(:params) { { product_category_id: product_category.id } }

      before { product_category }

      specify { expect(subject).to eq(params) }
    end

    context "when product category doesn't exist" do
      let(:params) { { product_category_id: category_struct.product_category.id } }

      specify { expect(subject).to eq(params) }
    end
  end
end
