describe PaymentsController do
  # TODO fix this test with current order email. Make testfor order with email and without
  let(:order) { create :order, :with_email }
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
      orderNumber: order_number
    }
  }

  shared_examples_for 'payment failed response' do
    it 'should be equel failed response' do
      subject
      response_xml = Nokogiri::XML(response.body).children[0]
      notification_xml = Nokogiri::XML(notification.error_response(1, message: I18n.t('inconsistency_of_data'))).children[0]

      expect(response_xml.attributes['code'].value)
        .to eq notification_xml.attributes['code'].value
      expect(response_xml.attributes['invoiceId'].value)
        .to eq notification_xml.attributes['invoiceId'].value
      expect(response_xml.attributes['shopId'].value)
        .to eq notification_xml.attributes['shopId'].value
      expect(response_xml.attributes['message'].value)
        .to eq notification_xml.attributes['message'].value
    end
  end

  shared_examples_for 'payment success response' do
    it 'should be equel success response' do
      subject
      response_xml = Nokogiri::XML(response.body).children[0]
      notification_xml = Nokogiri::XML(notification.success_response).children[0]

      expect(response_xml.attributes['code'].value)
        .to eq notification_xml.attributes['code'].value
      expect(response_xml.attributes['invoiceId'].value)
        .to eq notification_xml.attributes['invoiceId'].value
      expect(response_xml.attributes['shopId'].value)
        .to eq notification_xml.attributes['shopId'].value
    end
  end

  shared_examples_for "user doesn't exists" do
    context "when customer doesn't exists" do
      let(:customer_email) { nil }

      it_behaves_like 'payment failed response'
    end
  end

  before { request.env['HTTPS'] = 'on' }

  # TODO refactor me, like webmock
  describe 'POST /payments/check' do
    let(:payment_action) { 'checkOrder' }

    subject { post :check, params }

    it_behaves_like 'a successful request'
    it_behaves_like 'payment success response'
    it_behaves_like "user doesn't exists"

    context "when order was created for not authorizes user" do
      let(:order) { create :order, :without_user }

      it_behaves_like 'a successful request'

      context "when customerNumber doesn't correct" do
        let(:customer_email) { Faker::Internet.email }

        it_behaves_like 'payment failed response'
      end
    end
  end

  describe 'POST /payments/status' do
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
