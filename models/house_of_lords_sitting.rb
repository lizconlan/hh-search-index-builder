# encoding: utf-8

class HouseOfLordsSitting < Sitting
  def self.anchor
    self.uri_component
  end

  def self.house
    'Lords'
  end

  def self.uri_component
    'lords'
  end
end