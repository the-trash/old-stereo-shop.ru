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

    {
      :"characteristics" => :characteristics_products,
      :"stores" => :products_stores
    }.each do |k, v|
      it { should have_many(v).dependent(:destroy) }
      it { should have_many(k).through(v) }
    end
  end

  context 'validates' do
    %i(title description product_category_id admin_user_id brand_id).each do |f|
      it { should validate_presence_of(f) }
    end

    %i(products_stores characteristics_products).each do |r|
      it { should accept_nested_attributes_for(r).allow_destroy(true) }
    end
  end

  it { should delegate(:title).to(:product_category).with_prefix }
end
