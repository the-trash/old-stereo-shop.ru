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

  describe '#default' do
    let!(:product) { create :product }

    subject { product.photos.default }

    context "when default photo doesn't exist" do
      let!(:photo) { create :photo, photoable: product }

      specify { expect(subject).to eq photo }

      it 'should not receive #set_correct_default' do
        expect(photo).not_to receive(:set_correct_default)
        photo.save
      end
    end

    context 'when default photo exists' do
      let!(:default_photo) { create :photo, :default, photoable: product }
      let(:photo) { build :photo, :default, photoable: product }

      specify { expect(subject).to eq(default_photo) }

      it 'should receive #set_correct_default' do
        expect(photo).to receive(:set_correct_default)
        photo.save
      end

      it 'previos default photo should be updated to false' do
        photo.save
        expect(default_photo.reload.default).to be_falsey
      end
    end
  end
end
