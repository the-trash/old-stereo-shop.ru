# == Schema Information
#
# Table name: elco_imports
#
#  id           :integer          not null, primary key
#  elco_success :text
#  elco_errors  :text
#  state        :string           default("pending")
#  finished_at  :datetime
#  created_at   :datetime
#  updated_at   :datetime
#
require 'savon'

class ElcoImport < ActiveRecord::Base
  LOGIN    = "Art_el"
  PASSWORD = "12345678"

  scope :in_progress, ->{ where(state: :in_progress) }

  # 1182555
  def start_import!
    return :already_done if self.state == 'finished'
    return :in_progress  if !ElcoImport.in_progress.count.zero?

    errors_ary  = []
    success_ary = []

    client = ::Savon.client do
      wsdl "https://ecom.elko.ru/xml/listener.asmx?WSDL"
      convert_request_keys_to :camelcase
    end

    products = ::Product.published.where.not(elco_id: [nil, ''])

    if products.blank?
      update(state: :finished)
      return :no_products
    end

    update_column(:state, :in_progress)

    products.each do |product|
      msg = {
        username: LOGIN,
        password: PASSWORD,
        ELKOcode: product.elco_id,
        CategoryCode: '',
        VendorCode: ''
      }

      begin
        response = client.call(:catalog_product_list, message: msg)

        if response.xpath('//Response/Success').text == 'True'
          # vendor: response.xpath('//product/vendor').text
          elco_data = {
            id:     response.xpath('//product/id').text,
            name:   response.xpath('//product/name').text,
            price:  response.xpath('//product/price').text,
            spb:    response.xpath('//product/quantityInStock').text,
            msk:    response.xpath('//product/quantityInStock_MOS').text
          }
          success_ary.push(elco_data)

          in_stock = (elco_data[:spb].to_i > 0) || (elco_data[:msk].to_i > 0)

          product.update_columns({
            in_stock: in_stock,
            elco_state: :success,
            elco_amount_home: elco_data[:spb],
            elco_amount_msk:  elco_data[:msk],
            elco_price:       elco_data[:price],
            elco_updated_at:  Time.zone.now,
            elco_errors: ''
          })
        else
          elco_data = {
            id: msg[:ELKOcode],
            message: response.xpath('//Response/Message').text
          }
          errors_ary.push(elco_data)

          product.update_columns({
            elco_state: :failed,
            elco_errors: elco_data.join
          })
        end
      rescue Exception => e
        product.update_columns({
          elco_state: :failed,
          elco_errors: e.message,
          elco_updated_at: Time.zone.now
        })
      end
    end

    update_columns({
      elco_success: success_ary.map{|succ| "<p>#{succ}</p>"}.join,
      elco_errors:  errors_ary.map{|error| "<p>#{error}</p>"}.join,
      finished_at: Time.zone.now,
      state: :finished
    })

    return :finished
  end
end