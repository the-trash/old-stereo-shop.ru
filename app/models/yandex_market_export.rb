# == Schema Information
#
# Table name: yandex_market_exports
#
#  id             :integer          not null, primary key
#  state          :string(255)
#  file           :string(255)
#  error_messages :text
#  created_at     :datetime
#  updated_at     :datetime
#

class YandexMarketExport < ActiveRecord::Base
  include StateMachineHelper

  after_commit :start!, on: :create, if: :created?

  mount_uploader :file, CsvFileUploader do
    def store_dir
      "uploads/yandex_market/#{ Rails.env }"
    end
  end

  state_machine :state, initial: :created do
    %i(created started completed failed).each { |st| state st }

    event :start do
      transition created: :started
    end

    event :complete do
      transition started: :completed
    end

    after_transition created: :started, do: :start_export_job
  end

  private

  def start_export_job
    YandexMarketExportWorker.perform_async id
  end
end
