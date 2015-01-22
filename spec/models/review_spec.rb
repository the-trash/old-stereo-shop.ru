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

      subject { review.save }

      context 'when review has state draft' do
        let(:state) { :draft }

        it_behaves_like 'not_to_receive_by_callback_name', :increment_recallable_cache_counters
      end

      described_class::STATES.reject{ |state| state == :draft }.each do |st|
        context "when review hasn't state draft" do
          let(:state) { st }

          it_behaves_like 'to_receive_by_callback_name', :increment_recallable_cache_counters
        end
      end

      context "when state was changed" do
        let(:state) { :published }

        before { subject }

        context 'when state draft' do
          before { review.state = :draft }

          it_behaves_like 'not_to_receive_by_callback_name', :recalculate_product_cache_counters
        end
      end
    end

    context "when review doesn't for product" do

    end
  end
end
