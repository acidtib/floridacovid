# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

country = Country.create(
  name: "US",
  slug: "us",
  lat: "40", 
  long: "-100"
)

state = country.states.create(
  name: "Florida",
  slug: "florida",
  lat: "27.766279", 
  long: "-81.686783"
)

state.state_stats.create(
  positive_residents: 14065,
  positive_non_residents: 439,
  deaths: 283,
  results_total: 138618,
  results_negative: 122792,
  recovered: 0,
  being_monitored: 1777
)