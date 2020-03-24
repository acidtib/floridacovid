class State < ActiveRecord::Base
  has_many :stats
  has_many :counties
end