describe Review do
  context 'concerns' do
    it_behaves_like('statable')
  end

  context 'relations' do
    %i(user recallable).each do |r|
      it { should belong_to(r).counter_cache(true) }
    end

    it { should belong_to(:rating).dependent(:destroy) }
  end

  context 'validates' do
    %i(recallable body user_id rating_id).each do |f|
      it { should validate_presence_of(f) }
    end
  end

  describe '.related' do
    let!(:related_review) { create :review }
    let!(:not_related_review) { create :review, :not_related }

    subject { described_class.related }

    specify { expect(subject).to include(related_review) }
    specify { expect(subject).not_to include(not_related_review) }
  end
end
