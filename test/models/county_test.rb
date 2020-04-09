require 'test_helper'

class CountyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: counties
#
#  id         :bigint           not null, primary key
#  lat        :string
#  long       :string
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state_id   :bigint
#
# Indexes
#
#  index_counties_on_state_id  (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (state_id => states.id)
#
