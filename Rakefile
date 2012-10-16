require 'bundler'
Bundler.setup

require 'rake'
require 'mysql'
require 'sunspot'
require 'active_record'
require 'sinatra'

require './models/contribution'
require './models/commons_membership'
require './models/lords_membership'
require './models/member_contribution'
require './models/procedural_contribution'
require './models/person'
require './models/section'
require './models/sitting'
require './models/house_of_commons_sitting'
require './models/house_of_lords_sitting'
require './models/house_of_lords_report'
require './models/westminster_hall_sitting'
require './models/written_answers_sitting'
require './models/written_statements_sitting'
require './models/commons_written_answers_sitting'
require './models/commons_written_statements_sitting'
require './models/grand_committee_report_sitting'
require './models/lords_written_answers_sitting'
require './models/lords_written_statements_sitting'


task :test do
  #Sunspot.config.solr.url = ENV['WEBSOLR_URL'] || YAML::load(File.read("config/websolr.yml"))[:websolr_url]
  
  dbconfig = YAML::load(File.open 'config/database.yml')[ Sinatra::Application.environment.to_s ]
  ActiveRecord::Base.establish_connection(dbconfig)
  
  p ""
  c = Contribution.find(205)
  p c.section.title
  p c.url
  p c.sitting.sitting_type_name
  p c.section.date
  p c.speaker_name
  p c.speaker_url
end