describe PostCategory do
  let(:post_category) { FactoryGirl.create(:post_category) }

  context 'concerns' do
    %w(photoable friendable statable).each do |concern|
      it_behaves_like(concern)
    end
  end

  context 'relations' do
    it { should belong_to(:admin_user) }
    it { should have_many(:posts).dependent(:destroy) }
  end

  context 'validates' do
    %i(title admin_user_id).each do |f|
      it { should validate_presence_of(f) }
    end
  end

  context 'class methods' do
    it 'for_select' do
      post_category

      expect(PostCategory.for_select).
        to include([post_category.title, post_category.id])
    end
  end
end
