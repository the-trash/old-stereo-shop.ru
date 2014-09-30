describe Store do
  context 'concerns' do
    %w(friendable statable).each do |concern|
      it_behaves_like(concern)
    end
  end

  context 'relations' do
    it { should belong_to(:admin_user) }

    it { should have_many(:products_stores).dependent(:destroy) }
    it { should have_many(:products).through(:products_stores) }
  end

  context 'validates' do
    %i(title admin_user).each do |f|
      it { should validate_presence_of(f) }
    end
  end
end
