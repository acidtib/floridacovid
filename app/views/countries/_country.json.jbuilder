json.extract! country, :id, :name, :slug, :lat, :long, :created_at, :updated_at
json.url country_url(country, format: :json)
