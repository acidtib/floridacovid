source "https://rubygems.org"
git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

ruby '2.6.5'

gem "sinatra"
gem "sinatra-contrib"
gem "activerecord"
gem "sinatra-activerecord"
gem "sinatra-cross_origin"
gem "rake"
gem "pg"
gem "nokogiri"
gem "httparty"

group :production do
  gem "puma"
  gem "rack-ssl-enforcer"
end