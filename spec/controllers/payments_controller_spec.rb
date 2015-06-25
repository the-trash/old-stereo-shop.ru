describe PaymentsController do
  let!(:order) { create :order }
  let(:order_number) { order.id }
  let(:time_now) { Time.zone.now }
  let(:notification) { YANDEX_CASHBOX.notification(params.to_query) }
  let(:gross) { order.total_amount }
  let(:order_sum_currency_paycash) { 643 }
  let(:order_sum_bank_paycash) { 1001 }
  let(:invoice_id) { 1234567 }
  let(:customer_email) { order.email }
  let(:tmp_md5) {
    Digest::MD5.hexdigest \
      [
        payment_action,
        gross,
        order_sum_currency_paycash,
        order_sum_bank_paycash,
        Settings.yandex_cashbox.shop_id,
        invoice_id,
        order.email,
        Settings.yandex_cashbox.shop_password
      ].compact.join(';')
  }
  let(:md5) { tmp_md5.upcase}
  let(:params) {
    {
      orderSumAmount: gross,
      orderSumCurrencyPaycash: order_sum_currency_paycash,
      orderSumBankPaycash: order_sum_bank_paycash,
      shopId: Settings.yandex_cashbox.shop_id,
      invoiceId: invoice_id,
      customerNumber: customer_email,
      requestDatetime: time_now,
      orderCreatedDatetime: time_now,
      paymentDatetime: time_now,
      md5: md5,
      shopSumAmount: gross,
      shopSumCurrencyPaycash: order_sum_currency_paycash,
      paymentPayerCode: 42007148320,
      paymentType: 'AC',
      shopSumBankPaycash: order_sum_bank_paycash,
      orderNumber: order_number,
      action: action,
      payment_action: payment_action
    }
  }

  shared_examples_for 'payment failed response' do
    it 'should be equel failed response' do
      subject
      expect(response.body).to eq notification.error_response(1, message: I18n.t('inconsistency_of_data'))
    end
  end

  shared_examples_for 'payment success response' do
    it 'should be equel success response' do
      subject
      expect(response.body).to eq notification.success_response
    end
  end

  shared_examples_for "user doesn't exists" do
    context "when customer doesn't exists" do
      let(:customer_email) { 'nil' }

      it_behaves_like 'payment failed response'
    end
  end

  before { request.env['HTTPS'] = 'on' }

  # TODO refactor me, like webmock
  describe 'POST /payments/check' do
    let(:action) { 'check' }
    let(:payment_action) { 'checkOrder' }

    subject { post :check, params }

    it_behaves_like 'a successful request'
    it_behaves_like 'payment success response'
    it_behaves_like "user doesn't exists"
  end

  describe 'POST /payments/status' do
    let(:action) { 'status' }
    let(:payment_action) { 'paymentAviso' }

    subject { post :status, params }

    it_behaves_like 'a successful request'
    it_behaves_like 'payment success response'
    it_behaves_like "user doesn't exists"

    specify {
      expect{ subject }.to change{ PaymentTransaction.count }.from(0).to(1)
    }

    context "when order from params doesn't exists" do
      let(:order_number) { 'f' }

      it_behaves_like 'payment failed response'

      specify {
        expect{ subject }.not_to change{ PaymentTransaction.count }.from(0)
      }
    end
  end

  describe 'GET /payments/fail' do
    it_behaves_like 'a successful request'
    # it_behaves_like 'a successful render template', 'fail'
  end

  describe 'GET /payments/success' do
    it_behaves_like 'a successful request'
    # it_behaves_like 'a successful render template', 'success'
  end
end
