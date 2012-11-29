# encoding: utf-8

class Section < ActiveRecord::Base
  has_many :contributions
  belongs_to :sitting
end