describe CharacteristicCategory do
  let(:characteristic_category) { FactoryGirl.create(:characteristic_category) }

  context 'relations' do
    it { should belong_to(:admin_user) }

    it { should have_many(:characteristics).dependent(:destroy) }
  end

  context 'validates' do
    it { should validate_presence_of(:title) }
  end

  context 'class methods' do
    it 'for_select' do
      characteristic_category

      expect(CharacteristicCategory.for_select).
        to include([characteristic_category.title, characteristic_category.id])
    end
  end
end
