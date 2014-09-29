describe Photo do
  # context 'concerns' do
  #   %w(statable).each do |concern|
  #     it_behaves_like(concern)
  #   end
  # end

  context 'relations' do
    it { should belong_to(:photoable) }
  end

  context 'validates' do
    %i(photoable file).each do |f|
      it { should validate_presence_of(f) }
    end
  end
end
