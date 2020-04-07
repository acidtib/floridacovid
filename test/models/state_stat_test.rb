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
#  being_monitored        :bigint
#  deaths                 :bigint
#  positive_non_residents :bigint
#  positive_residents     :bigint
#  recovered              :bigint
#  results_negative       :bigint
#  results_total          :bigint
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
