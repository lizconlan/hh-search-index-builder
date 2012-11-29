incompatible character encodings: ASCII-8BIT and UTF-8

class CommonsMembership < ActiveRecord::Base
  belongs_to :person
  has_many :commons_contributions, :class_name => "Contribution"
end