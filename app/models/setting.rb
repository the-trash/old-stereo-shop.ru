# == Schema Information
#
# Table name: settings
#
#  id          :integer          not null, primary key
#  key         :string
#  value       :string
#  description :string
#  group       :string
#  created_at  :datetime
#  updated_at  :datetime
#

class Setting < ActiveRecord::Base
  validates :key, :group, presence: true
  validates :key, uniqueness: true

  after_save :set_global_variable

  def self.make_hash
    self.all.inject({}) do |hash, setting|
      hash[setting.key] = setting.value
      hash
    end.with_indifferent_access
  end

  private

  def set_global_variable
    $settings = Setting.make_hash
  end
end
