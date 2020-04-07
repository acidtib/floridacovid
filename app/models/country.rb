class Country < ApplicationRecord
  has_many :country_stats
  has_many :states
end
