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

  describe '#save' do
    subject { review.save }

    shared_examples_for 'not_to_receive_by_callback_name' do |callback_name|
      it 'should not be receive callback' do
        expect(review).not_to receive(callback_name)
        subject
      end
    end

    shared_examples_for 'to_receive_by_callback_name' do |callback_name|
      it 'should be receive callback' do
        expect(review).to receive(callback_name)
        subject
      end
    end

    context 'when review for product' do
      let(:review) { build :review, state }

      described_class::STATES.each do |st|
        context "when state was changed" do
          let(:state) { st }

          it_behaves_like 'to_receive_by_callback_name', :increment_recallable_cache_counters
        end
      end
    end

    context "when state was changed for other recallable type" do
      let(:user) { create :user }
      let(:review) { build :review, :published, recallable: user }

      before { subject }

      context 'when state draft' do
        before { review.state = :draft }

        it_behaves_like 'not_to_receive_by_callback_name', :recalculate_product_cache_counters
      end
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
