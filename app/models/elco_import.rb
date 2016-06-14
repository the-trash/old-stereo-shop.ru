# == Schema Information
#
# Table name: elco_imports
#
#  id               :integer          not null, primary key
#  elco_success     :text
#  elco_errors      :text
#  state            :string           default("pending")
#  finished_at      :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  items_to_process :integer          default(0)
#  items_processed  :integer          default(0)
#

require 'savon'

class ElcoImport < ActiveRecord::Base
  LOGIN    = "Art_el"
  PASSWORD = "12345678"

  scope :in_progress, ->{ where(state: :in_progress) }

  # ElcoImport.last.restart_import!
  def restart_import!
    update(state: :pending)
    start_import!
  end

  # 1182555
  # ElcoImport.last.restart_import!
  def start_import!
    return :already_done if self.state == 'finished'
    return :in_progress  if !ElcoImport.in_progress.count.zero?

    errors_ary  = []
    success_ary = []

    products = ::Product.where.not(elco_id: [nil, ''])

    if products.blank?
      update(state: :finished)
      return :no_products
    end

    update_columns({
      state: :in_progress,
      items_to_process: products.count
    })

    products.each_with_index do |product, index|
      status, elco_data = product.get_elco_data!

      if status == :success
        success_ary.push(elco_data)
      else
        errors_ary.push(elco_data)
      end

      update_column(:items_processed, index.next)
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
