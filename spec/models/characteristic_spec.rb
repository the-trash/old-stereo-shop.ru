describe Characteristic do
  context 'relations' do
    it { should belong_to(:characteristic_category) }

    it { should have_many(:characteristics_products).dependent(:destroy) }
    it { should have_many(:products).through(:characteristics_products) }
  end

  context 'validates' do
    %i(title unit characteristic_category_id).each do |f|
      it { should validate_presence_of(f) }
    end
  end

  it { should delegate(:title).to(:characteristic_category).with_prefix }
end
