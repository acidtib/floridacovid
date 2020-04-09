class AgeStat < ApplicationRecord
  belongs_to :state

  def self.today
    where(created_at: Time.zone.today.all_day)
  end
end

# == Schema Information
#
# Table name: age_stats
#
#  id         :bigint           not null, primary key
#  a_0_4      :bigint           default("0")
#  a_15_24    :bigint           default("0")
#  a_25_34    :bigint           default("0")
#  a_35_44    :bigint           default("0")
#  a_45_54    :bigint           default("0")
#  a_55_64    :bigint           default("0")
#  a_5_14     :bigint           default("0")
#  a_65_74    :bigint           default("0")
#  a_75_84    :bigint           default("0")
#  a_85plus   :bigint           default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state_id   :bigint
#
# Indexes
#
#  index_age_stats_on_state_id  (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (state_id => states.id)
#
