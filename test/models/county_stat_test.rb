require 'test_helper'

class CountyStatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: county_stats
#
#  id            :bigint           not null, primary key
#  deaths        :bigint
#  non_residents :bigint
#  residents     :bigint
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
