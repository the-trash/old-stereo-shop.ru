class PaymentsController < FrontController
  skip_before_action :verify_authenticity_token, only: [:check, :status]
  skip_before_filter :set_variables, :store_location, only: [:check, :status]

  before_filter :set_notification, only: [:check, :status]
  before_filter :set_order, only: [:status, :fail]

  def check
    if @notification.valid_sender?(request.remote_ip) && @notification.acknowledge?
      render xml: @notification.success_response
    else
      render xml: @notification.error_response(1, message: I18n.t('inconsistency_of_data'))
    end
  end

  def status
    if @notification.valid_sender?(request.remote_ip) && @notification.acknowledge? && @order
      create_transaction
      @order.paid_up!
      render xml: @notification.success_response
    else
      render xml: @notification.error_response(1, message: I18n.t('inconsistency_of_data'))
    end
  end

  def fail
    add_breadcrumb I18n.t('payment_fail')
  end

  def success
    add_breadcrumb I18n.t('payment_success')
  end

  private

  def transaction_params
    params.permit(
      :requestDatetime, :md5, :shopId, :shopArticleId, :invoiceId, :orderNumber,
      :customerNumber, :orderCreatedDatetime, :orderSumAmount, :orderSumCurrencyPaycash,
      :orderSumBankPaycash, :shopSumAmount, :shopSumCurrencyPaycash, :shopSumBankPaycash,
      :paymentPayerCode, :paymentType, :cps_user_country_code
    )
  end

  def underscored_transaction_params
    {}.tap do |underscored_params|
      params.permit(
        :requestDatetime, :md5, :shopId, :invoiceId, :customerNumber, :orderCreatedDatetime,
        :orderSumAmount, :orderSumCurrencyPaycash, :orderSumBankPaycash,
        :shopSumAmount, :shopSumCurrencyPaycash, :shopSumBankPaycash,
        :paymentPayerCode, :paymentType, :cps_user_country_code
      ).each { |k, v| underscored_params[k.underscore] = v }
    end
  end

  def set_order
    @order =
      begin
        Order.find params[:orderNumber]
      rescue ActiveRecord::RecordNotFound
        nil
      end
  end

  def set_notification
    @notification = YANDEX_CASHBOX.notification [transaction_params.to_query, "payment_action=#{payment_action}"].join('&')
  end

  def create_transaction
    @order.create_payment_transaction underscored_transaction_params
  end

  def payment_action
    action_name == 'check' ? 'checkOrder' : 'paymentAviso'
  end
end
