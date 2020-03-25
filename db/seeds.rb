state = State.create(
  name: "Florida",
  slug: "florida",
  latitude: "27.766279", 
  longitude: "-81.686783"
)

state.stats.create(
  positive_residents: 1330, 
  cases_repatriated: nil, 
  non_residents: 82, 
  deaths: 18, 
  results_negative: 13127, 
  results_pending: 1008, 
  being_monitored: 1249, 
  total_monitored: nil, 
  recovered: 0, 
  last_update: "2020-03-24 16:45:50 +0000", 
  age_0_4: 2,
  age_5_14: 9, 
  age_15_24: 47, 
  age_25_34: 188, 
  age_35_44: 196, 
  age_45_54: 204, 
  age_55_64: 247, 
  age_65_74: 249, 
  age_75_84: 178, 
  age_85plus: 93
)

state.counties.create(
  name: "ALACHUA",
  slug: "alachua",
  residents: 34,
  non_residents: 3,
  deaths: 0,
  last_update: "2020-03-24 16:45:50 +0000", 
)

Country.create(
  name: "US",
  slug: "us",
  confirmed: 46805, 
  recovered: 0, 
  deaths: 593, 
  last_update: "2020-03-24 16:04:17", 
  latitude: "40", 
  longitude: "-100"
)