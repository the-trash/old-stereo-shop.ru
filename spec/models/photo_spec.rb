describe Photo do
  # context 'concerns' do
  #   it_behaves_like('statable')
  # end

  context 'relations' do
    it { should belong_to(:photoable) }
  end

  context 'validates' do
    it { should validate_presence_of(:file) }
  end
end
