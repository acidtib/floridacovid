class State < ApplicationRecord
  belongs_to :country
  has_many :state_stats
  has_many :age_stats
  has_many :counties
end
