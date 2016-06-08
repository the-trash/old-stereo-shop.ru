# == Schema Information
#
# Table name: seo_settings
#
#  id              :integer          not null, primary key
#  controller_name :string(255)
#  action_name     :string(255)
#  meta            :hstore           default({}), not null
#  created_at      :datetime
#  updated_at      :datetime
#
# Indexes
#
#  index_seo_settings_on_controller_name_and_action_name  (controller_name,action_name)
#

class SeoSetting < ActiveRecord::Base
  include Seoble

  attr_accessor :url

  validates :controller_name, :action_name, presence: true

  before_validation :parse_url

  private

  def parse_url
    return unless url.present?

    route = Rails.application.routes.recognize_path url
    self.controller_name = route[:controller]
    self.action_name = route[:action]
  end
end
