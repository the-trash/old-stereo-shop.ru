describe ReviewForm do
  let(:product) { create :product }
  let(:user) { create :user }
  let(:review) { ReviewDecorator.decorate build :review, :without_rating, user: user, recallable: product }
  let(:params) {
    {
      body: Faker::Lorem.sentence,
      rating_score: 2,
      recallable_id: product.id
    }
  }

  subject { described_class.new(review, params).save }

  context 'when all data correct' do
    specify { expect(subject).to be_truthy }
    specify { expect{ subject }.to change{ Review.count }.by(1) }
    specify { expect{ subject }.to change{ Rating.count }.by(1) }

    context 'when user wants to be anonymous' do
      let(:params) {
        {
          body: Faker::Lorem.sentence,
          rating_score: 2,
          recallable_id: product.id,
          leave_anonymous_review: true
        }
      }
      before { subject }

      specify { expect(Review.first.user_name).to eq I18n.t('anonymous_user') }
    end
  end

  context 'when data does not correct' do
    let(:params) { { recallable_id: product.id } }

    specify { expect(subject).to be_falsy }
    specify { expect{ subject }.not_to change{ Review.count } }
    specify { expect{ subject }.not_to change{ Rating.count } }
  end
end
