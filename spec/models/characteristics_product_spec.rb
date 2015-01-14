describe CharacteristicsProduct do
  context 'relations' do
    %i(characteristic product).each do |m|
      it { should belong_to(m) }
    end
  end

  context 'validates' do
    it { should validate_presence_of(:value) }
  end

  it { should delegate(:characteristic_category_title).to(:characteristic).with_prefix }
end
