class StateStat < ApplicationRecord
  belongs_to :state
  has_one :age_stat

  def self.today
    where(created_at: Time.zone.today.all_day)
  end
end
