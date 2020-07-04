class County < ApplicationRecord
  belongs_to :state
  has_many :county_stats
  has_many :cases
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
