class HouseOfLordsReport < Sitting
  def self.anchor
    self.uri_component
  end
  
  def self.uri_component
    'lords_reports'
  end
  
  def self.house
    'Lords'
  end
end