class State < ApplicationRecord
  belongs_to :country
  has_many :state_stats
end
