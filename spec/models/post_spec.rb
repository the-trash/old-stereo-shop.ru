describe Post do
  context 'concerns' do
    %w(photoable friendable statable).each do |concern|
      it_behaves_like(concern)
    end
  end

  context 'relations' do
    %i(admin_user post_category).each do |m|
      it { should belong_to(m) }
    end
  end

  context 'validates' do
    %i(title admin_user_id post_category_id).each do |f|
      it { should validate_presence_of(f) }
    end
  end
end
