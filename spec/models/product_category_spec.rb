describe ProductCategory do
  let(:product_category) { FactoryGirl.create(:product_category) }

  context 'concerns' do
    %w(photoable friendable statable).each do |concern|
      it_behaves_like(concern)
    end
  end

  context 'relations' do
    it { should belong_to(:admin_user) }
    it { should have_many(:products).dependent(:destroy) }
  end

  context 'validates' do
    it { should validate_presence_of(:title) }
  end

  context 'class methods' do
    it 'for_select' do
      product_category

      expect(ProductCategory.for_select).
        to include([product_category.title, product_category.id])
    end
  end
end
