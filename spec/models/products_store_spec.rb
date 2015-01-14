describe ProductsStore do
  context 'relations' do
    %i(store product).each do |m|
      it { should belong_to(m) }
    end
  end

  context 'validates' do
    it { should validate_presence_of(:count) }
  end

  it { should delegate(:title).to(:store).with_prefix }
end
