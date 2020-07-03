class Case < ApplicationRecord
  belongs_to :county
  belongs_to :state
end

# == Schema Information
#
# Table name: cases
#
#  id             :bigint           not null, primary key
#  age            :string
#  age_group      :string
#  case_          :string
#  case_date      :datetime
#  chart_date     :datetime
#  contact        :string
#  died           :string
#  ed_visit       :string
#  event_date     :datetime
#  gender         :string
#  hospitalized   :string
#  jurisdiction   :string
#  origin         :string
#  travel_related :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  county_id      :bigint
#  object_id      :integer
#  state_id       :bigint
#
# Indexes
#
#  index_cases_on_county_id  (county_id)
#  index_cases_on_state_id   (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (county_id => counties.id)
#  fk_rails_...  (state_id => states.id)
#
