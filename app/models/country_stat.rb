class CountryStat < ApplicationRecord
  belongs_to :country

  def self.today
    where(created_at: Time.zone.today.all_day)
  end
end
