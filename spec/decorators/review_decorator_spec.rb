describe ReviewDecorator do
  let(:product) { create :product }
  let(:user) { create :user }
  let(:review) { create :review, user: user, recallable: product }

  context '#anonymous_user' do
    subject { described_class.decorate(review).anonymous_user }

    specify { expect(subject).to eq I18n.t('anonymous_user') }
  end

  context '#correct_user_name' do
    subject { described_class.decorate(review).correct_user_name }

    context 'when review has user' do
      specify { expect(subject).to eq user.full_name }

      context 'when user without full_name' do
        let(:user) { create :user, :without_name }

        specify { expect(subject).to eq user.email }
      end
    end

    context 'when review has not user' do
      let(:review) { create :review, :without_user, recallable: product }

      specify { expect(subject).to eq I18n.t('anonymous_user') }
    end
  end
end
