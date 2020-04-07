class County < ApplicationRecord
  belongs_to :state
  has_many :county_stats
end
