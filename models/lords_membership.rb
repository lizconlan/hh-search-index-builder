# encoding: utf-8

class LordsMembership < ActiveRecord::Base
  belongs_to :person
  has_many :lords_contributions, :class_name => "Contribution"
end