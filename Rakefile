# encoding: utf-8

require 'bundler'
Bundler.setup

require 'rake'
require 'active_record'

require './models/contribution'
require './models/commons_membership'
require './models/lords_membership'
require './models/member_contribution'
require './models/written_member_contribution'
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
require './models/division_placeholder'
require './models/unparsed_division_placeholder'
require './models/table_contribution'
require './models/quote_contribution'
require './models/oral_question_section'
require './models/oral_questions_section'

require './lib/indexer'


task :test do  
  dbconfig = YAML::load(File.open 'config/database.yml')
  ActiveRecord::Base.establish_connection(dbconfig)
  
  p ""
  c = Contribution.find(205)
  p c.section.title
  p c.url
  p c.sitting.sitting_type_name
  p c.section.date
  p c.speaker_name
  p c.speaker_url
  p c.solr_text
end

task :index_contributions do
  dbconfig = YAML::load(File.open 'config/database.yml')
  ActiveRecord::Base.establish_connection(dbconfig)
  
  indexer = Indexer.new
  
  Contribution.find_each do |contribution|
    p contribution.subject
    indexer.add_document(contribution)
  end
end