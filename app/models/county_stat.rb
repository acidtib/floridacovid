class CountyStat < ApplicationRecord
  belongs_to :county

  def self.today
    where(created_at: Time.zone.today.all_day)
  end
end
