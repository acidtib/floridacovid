require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

self.instance_eval do
  alias :namespace_pre_sinatra :namespace if self.respond_to?(:namespace, true)
end
require 'sinatra/namespace'
self.instance_eval do
  alias :namespace :namespace_pre_sinatra if self.respond_to?(:namespace_pre_sinatra, true)
end

require './app'

require 'open-uri'
require 'nokogiri'
require 'httparty'
require 'json'
require 'pp'

Dir.glob('./lib/tasks/*.rake').each { |r| import r }