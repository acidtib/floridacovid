class CountyStat < ApplicationRecord
  belongs_to :county

  def self.today
    where(created_at: Time.zone.today.all_day)
  end
end

# == Schema Information
#
# Table name: county_stats
#
#  id            :bigint           not null, primary key
#  deaths        :bigint           default("0")
#  non_residents :bigint           default("0")
#  residents     :bigint           default("0")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  county_id     :bigint
#
# Indexes
#
#  index_county_stats_on_county_id  (county_id)
#
# Foreign Keys
#
#  fk_rails_...  (county_id => counties.id)
#
