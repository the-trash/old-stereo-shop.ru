describe Product do
  context 'concerns' do
    %w(photoable ratable friendable statable).each do |concern|
      it_behaves_like(concern)
    end
  end

  context 'relations' do
    %i(admin_user product_category brand).each do |m|
      it { should belong_to(m) }
    end

    it { should have_many(:characteristics_products).dependent(:destroy) }
    it { should have_many(:characteristics).through(:characteristics_products) }
  end

  context 'validates' do
    %i(title description product_category_id admin_user_id brand_id).each do |f|
      it { should validate_presence_of(f) }
    end

    it { should accept_nested_attributes_for(:characteristics_products).allow_destroy(true) }
  end

  it { should delegate(:title).to(:product_category).with_prefix }
end
