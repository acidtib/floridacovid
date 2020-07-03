class Country < ApplicationRecord
  has_many :country_stats
  has_many :states
  has_many :cases
end

# == Schema Information
#
# Table name: countries
#
#  id         :bigint           not null, primary key
#  lat        :string
#  long       :string
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
