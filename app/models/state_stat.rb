class StateStat < ApplicationRecord
  belongs_to :state

  def self.today
    where(created_at: Time.zone.today.all_day)
  end
end
