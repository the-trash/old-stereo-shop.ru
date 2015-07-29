describe UserPolicy do
  subject { described_class }

  specify {
    expect{ described_class.new(User.new, nil) }
      .to raise_error(Pundit::NotAuthorizedError, I18n.t('you_should_be_logged_in'))
  }

  permissions :update? do
    let(:user) { create :user }
    let(:user2) { create :user }

    specify { expect(subject).to permit(user, user) }
    specify { expect(subject).not_to permit(user, user2) }
  end

  permissions :subscibe? do
    context 'when user can subscribe' do
      let(:user) { create :user, :unsubscribed }

      specify { expect(subject).to permit(user, user) }
    end

    context "when user can't subscribe" do
      let(:user) { create :user, :subscribed }

      specify { expect(subject).not_to permit(user, user) }
    end
  end
end
