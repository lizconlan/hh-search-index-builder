class WestminsterHallSitting < Sitting
  class << self
    def anchor
      uri_component
    end

    def house
      'Commons'
    end

    def uri_component
      'westminster_hall'
    end

    def hansard_reference_prefix
      "HC"
    end

    def hansard_reference_suffix
      "WH"
    end
  end
end