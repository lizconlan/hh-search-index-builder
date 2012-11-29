# encoding: utf-8

class HouseOfCommonsSitting < Sitting
  
  def self.anchor
    self.uri_component
  end

  def self.house
    'Commons'
  end

  def self.uri_component
    'commons'
  end
end