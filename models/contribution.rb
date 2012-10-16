require 'sunspot'
require 'htmlentities'

class Contribution < ActiveRecord::Base
  belongs_to :section
  belongs_to :commons_membership
  belongs_to :lords_membership
  
  # previous setup
  # acts_as_solr :fields => [:solr_text, {:person_id => :facet},
  #                                      {:date => :facet},
  #                                      {:year => :facet},
  #                                      {:decade => :facet},
  #                                      {:sitting_type => :facet}],
  #              :facets => [:person_id, {:date => :date}, :year, :decade ]  
  
  
  Sunspot.setup(Contribution) do
    string :sitting_type, :stored => true
    string :subject, :stored => true
    string :speaker_name, :stored => true
    string :speaker_url, :stored => true #instead of person_id
    text :text, :stored => true
    string :url, :stored => true
    time :date, :stored => true
    integer :year, :stored => true
    integer :decade, :stored => true
  end
  
  def person
    if commons_membership
      commons_membership.person
    elsif lords_membership
        lords_membership.person
    else
      nil
    end
  end
  
  def subject
    section.title
  end
  
  def url
    "/#{sitting.sitting_type_name}/#{date.strftime("%Y/%b/%d")}/#{section.slug}##{anchor_id}".downcase()
  end
  
  def person_id
    if commons_membership
      commons_membership.person_id
    elsif lords_membership
      lords_membership.person_id
    else
      nil
    end
  end
  
  def speaker_name
    if person
      person.name
    else
      nil
    end
  end
  
  def speaker_url
    if person
      "/people/#{person.slug}"
    else
      nil
    end
  end
  
  def solr_text
    return nil unless text
    solr_text = text.gsub(/<col>\d+<\/col>/, '')
    solr_text = strip_tags(solr_text)
    HTMLEntities.new.decode(solr_text)
  end
  
  def year
    date.year
  end
  
  def decade
    date.decade
  end

  def sitting
    section.sitting
  end

  def sitting_title
    sitting.title
  end

  def sitting_type
    section.sitting_type
  end

  def date
    section.date
  end
end

class InstanceAdapter < Sunspot::Adapters::InstanceAdapter
 def id
   @instance.id
 end
end

class DataAccessor < Sunspot::Adapters::DataAccessor
 def load(id)
   ""
 end
 
 def load_all(ids)
   []
 end
end
 
Sunspot::Adapters::DataAccessor.register(DataAccessor, Contribution)
Sunspot::Adapters::InstanceAdapter.register(InstanceAdapter, Contribution)