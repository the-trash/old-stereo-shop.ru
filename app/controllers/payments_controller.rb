class PaymentsController < ApplicationController
  force_ssl

  skip_before_action :verify_authenticity_token

  before_filter :add_payment_action
  before_filter :set_notification
  before_filter :set_order, only: [:status]

  def check
    respond_to do |format|
      format.xml do
        if @notification.valid_sender?(request.remote_ip) && @notification.acknowledge?
          render xml: @notification.success_response
        else
          render xml: @notification.error_response(1, message: I18n.t('inconsistency_of_data'))
        end
      end
    end
  end

  def status
    respond_to do |format|
      format.xml do
        if @notification.valid_sender?(request.remote_ip) && @notification.acknowledge? && @order
          create_transaction
          @order.paid_up!
          render xml: @notification.success_response
        else
          render xml: @notification.error_response(1, message: I18n.t('inconsistency_of_data'))
        end
      end
    end
  end

  def fail
  end

  def success
  end

  private

  def transaction_params
    params.permit(
      :requestDatetime, :md5, :shopId, :shopArticleId, :invoiceId, :payment_action,
      :customerNumber, :orderCreatedDatetime, :orderSumAmount, :orderSumCurrencyPaycash,
      :orderSumBankPaycash, :shopSumAmount, :shopSumCurrencyPaycash, :shopSumBankPaycash,
      :paymentPayerCode, :paymentType, :cps_user_country_code, :orderNumber
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
    @notification = YANDEX_CASHBOX.notification transaction_params.to_query
  end

  def create_transaction
    @order.create_payment_transaction underscored_transaction_params
  end

  def add_payment_action
    params.merge! payment_action: payment_action
  end

  def payment_action
    action_name == 'check' ? 'checkOrder' : 'paymentAviso'
  end
end
