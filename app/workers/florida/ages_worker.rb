class Florida::AgesWorker
  include Sidekiq::Worker

  def perform()
    state = State.find_by_slug("florida")

    get_ages = HTTParty.get("https://services1.arcgis.com/CY1LXxl9zlJeBuRZ/arcgis/rest/services/Florida_COVID19_Cases/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_0_4%22%2C%22outStatisticFieldName%22%3A%22C_Age_0_4%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_5_14%22%2C%22outStatisticFieldName%22%3A%22C_Age_5_14%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_15_24%22%2C%22outStatisticFieldName%22%3A%22C_Age_15_24%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_25_34%22%2C%22outStatisticFieldName%22%3A%22C_Age_25_34%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_35_44%22%2C%22outStatisticFieldName%22%3A%22C_Age_35_44%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_45_54%22%2C%22outStatisticFieldName%22%3A%22C_Age_45_54%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_55_64%22%2C%22outStatisticFieldName%22%3A%22C_Age_55_64%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_65_74%22%2C%22outStatisticFieldName%22%3A%22C_Age_65_74%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_75_84%22%2C%22outStatisticFieldName%22%3A%22C_Age_75_84%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_85plus%22%2C%22outStatisticFieldName%22%3A%22C_Age_85plus%22%7D%5D&cacheHint=true", { read_timeout: 120 })
    if get_ages.code == 200
      response = JSON.parse(get_ages.body)

      unless response["error"]
        last_age_stat = state.age_stats.today

        features = response["features"][0]["attributes"]

        if last_age_stat.count == 0
          state.age_stats.create(
            a_0_4: features["C_Age_0_4"],
            a_5_14: features["C_Age_5_14"],
            a_15_24: features["C_Age_15_24"],
            a_25_34: features["C_Age_25_34"],
            a_35_44: features["C_Age_35_44"],
            a_45_54: features["C_Age_45_54"],
            a_55_64: features["C_Age_55_64"],
            a_65_74: features["C_Age_65_74"],
            a_75_84: features["C_Age_75_84"],
            a_85plus: features["C_Age_85plus"]
          )
        else
          last_age_stat.last.update(
            a_0_4: features["C_Age_0_4"],
            a_5_14: features["C_Age_5_14"],
            a_15_24: features["C_Age_15_24"],
            a_25_34: features["C_Age_25_34"],
            a_35_44: features["C_Age_35_44"],
            a_45_54: features["C_Age_45_54"],
            a_55_64: features["C_Age_55_64"],
            a_65_74: features["C_Age_65_74"],
            a_75_84: features["C_Age_75_84"],
            a_85plus: features["C_Age_85plus"]
          )
        end
      end
    end
  end

end