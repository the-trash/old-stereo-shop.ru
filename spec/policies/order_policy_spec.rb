describe OrderPolicy do
  subject { described_class }

  permissions :update? do
    let!(:user) { create :user }
    let(:cart) { create :cart }
    let(:order) { create :order, cart: cart }

    specify { expect(subject).not_to permit(user, order) }

    context 'when order and user have the same cart' do
      let(:cart) { create :cart, user: user }
      let(:order) { create :order, cart: cart }

      specify { expect(subject).to permit(user, order) }
    end
  end

  permissions :show? do
    context 'when user does not exists' do
      let(:order) { create :order, :approved }

      specify { expect(subject).not_to permit(nil, order) }
    end

    context 'when order does not approved' do
      let!(:user) { create :user, :with_orders }

      specify { expect(subject).not_to permit(user, user.orders.first) }
    end

    context 'when order has current user and was approved' do
      let(:user) { create :user, :with_order_was_approved }

      specify { expect(subject).to permit(user, user.orders.first) }
    end

    context 'when user does not has current order' do
      let(:user) { create :user }
      let(:order) { create :order, :approved }

      specify { expect(subject).not_to permit(user, order) }
    end
  end
end
