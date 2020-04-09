require 'test_helper'

class CountryStatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: country_stats
#
#  id         :bigint           not null, primary key
#  confirmed  :bigint           default("0")
#  deaths     :bigint           default("0")
#  recovered  :bigint           default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :bigint
#
# Indexes
#
#  index_country_stats_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
