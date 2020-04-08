require 'test_helper'

class StateStatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
