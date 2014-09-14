class Setting < ActiveRecord::Base
  validates :key, :group, presence: true
  validates :key, uniqueness: true

  def self.make_hash
    self.all.inject({}) do |hash, setting|
      hash[setting.key] = setting.value
      hash
    end.with_indifferent_access
  end
end
