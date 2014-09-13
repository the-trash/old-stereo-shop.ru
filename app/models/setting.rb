class Setting < ActiveRecord::Base
  validates_presence_of :key, :group
  validates_uniqueness_of :key

  def self.make_hash
    self.all.inject({}) do |hash, setting|
      hash[setting.key] = setting.value
      hash
    end.with_indifferent_access
  end
end
