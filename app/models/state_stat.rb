class StateStat < ApplicationRecord
  belongs_to :state

  def self.today
    where(created_at: Time.zone.today.all_day)
  end
end

# == Schema Information
#
# Table name: state_stats
#
#  id                     :bigint           not null, primary key
#  being_monitored        :bigint           default("0")
#  deaths                 :bigint           default("0")
#  positive_non_residents :bigint           default("0")
#  positive_residents     :bigint           default("0")
#  recovered              :bigint           default("0")
#  results_negative       :bigint           default("0")
#  results_total          :bigint           default("0")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  state_id               :bigint
#
# Indexes
#
#  index_state_stats_on_state_id  (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (state_id => states.id)
#
