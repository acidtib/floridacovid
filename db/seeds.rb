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
  age_0_9: 9, 
  age_10_19: 47, 
  age_20_29: 188, 
  age_30_39: 196, 
  age_40_49: 204, 
  age_50_59: 247, 
  age_60_69: 249, 
  age_70_79: 178, 
  age_80plus: 93
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