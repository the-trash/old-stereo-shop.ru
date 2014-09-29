describe Brand do
  context 'concerns' do
    %w(friendable statable).each do |concern|
      it_behaves_like(concern)
    end
  end

  context 'relations' do
    it { should belong_to(:admin_user) }
    it { should have_many(:products).dependent(:destroy) }
  end

  context 'validates' do
    %i(title admin_user_id).each do |f|
      it { should validate_presence_of(f) }
    end
  end
end
