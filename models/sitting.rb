# encoding: utf-8

class Sitting < ActiveRecord::Base
  has_many :all_sections, :foreign_key => 'sitting_id', :class_name => "Section", :dependent => :destroy
  has_many :direct_descendents, :foreign_key => 'sitting_id', :class_name => "Section", :conditions => "parent_section_id is null"
  
  def self.uri_component
    'sittings'
  end

  def sitting_type_name
    self.class.sitting_type_name
  end
  
  def self.sitting_type_name
    uri_component.humanize.titleize
  end
end