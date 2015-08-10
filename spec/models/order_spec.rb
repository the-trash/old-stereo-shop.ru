describe Order do
  let(:cart) { create :cart, :with_products }
  let!(:order) { create :order, cart: cart }

  describe '#make_complete!' do
    let!(:line_item) { cart.line_items.first }
    let(:product_price) { line_item.price_with_discount }

    subject { order.make_complete! }

    specify { expect{ subject }.to change { order.state }.from('started').to('created') }
    specify { expect{ subject }.to change { order.line_items.count }.from(0).to(cart.line_items.size) }
    specify { expect{ subject }.to change { cart.reload.line_items.count }.from(3).to(0) }
    specify { expect{ subject }.to change { order.step }.to('complete') }
    specify do
      expect{ subject }.to change { line_item.reload.current_product_price }.from(0.0).to(product_price)
    end

    context 'when line items more than one' do
      let!(:second_line_item) { create :line_item, cart: cart }
      let(:total_amount) { cart.total_amount }

      specify { expect{subject}.to change{order.total_amount}.from(0).to(total_amount) }
    end
  end

  describe 'transitions' do
    let(:order) { create :order }

    shared_examples_for 'mails for user should be sent correct' do |count|
      it_behaves_like 'mail should be sent', count

      context "when user doesn't exist" do
        let(:order) { create :order, :without_user }

        it_behaves_like 'mail should be sent', count
      end

      context "when order doesn't have email" do
        let(:order) { create :order, :without_email }

        it_behaves_like 'mail should not be sent'
      end
    end

    shared_examples_for 'mail should be sent' do |count|
      specify { expect{ subject }.to change{ OrderMailer.deliveries.count }.from(0).to(count) }
    end

    shared_examples_for 'mail should not be sent' do
      specify { expect{ subject }.not_to change{ OrderMailer.deliveries.count }.from(0) }
    end

    describe '#make_complete' do
      subject { order.make_complete }

      it_behaves_like 'mail should be sent', 2

      context "when user doesn't exist" do
        let(:order) { create :order, :without_user }

        it_behaves_like 'mail should be sent', 2

        it 'should be sent for admins' do
          subject
          expect(OrderMailer.deliveries.map(&:to)).to include OrderMailer.default_admin_emails.split(', ')
        end
      end
    end

    describe '#forward' do
      subject { order.forward }

      it_behaves_like 'mails for user should be sent correct', 1
    end

    describe '#approve' do
      subject { order.approve }

      it_behaves_like 'mails for user should be sent correct', 1
    end

    describe '#arrive' do
      subject { order.arrive }

      it_behaves_like 'mails for user should be sent correct', 1
    end
  end

  describe '#validations' do
    describe '#not_cash_payment' do
      context "when order doesn't have delivery by mail" do
        subject { order.errors.messages }

        before { order.receive! }

        it { is_expected.to be_empty }
      end

      context 'when delivery by mail' do
        let(:order) { create :order, :delivery_by_mail, step: 2 }

        subject { order.errors.messages }

        before do
          order.payment = 1
          order.valid?
        end

        it { is_expected.to have_key :payment }
      end
    end
  end
end
