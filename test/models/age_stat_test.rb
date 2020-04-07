require 'test_helper'

class AgeStatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: age_stats
#
#  id         :bigint           not null, primary key
#  a_0_4      :bigint
#  a_15_24    :bigint
#  a_25_34    :bigint
#  a_35_44    :bigint
#  a_45_54    :bigint
#  a_55_64    :bigint
#  a_5_14     :bigint
#  a_65_74    :bigint
#  a_75_84    :bigint
#  a_85plus   :bigint
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
