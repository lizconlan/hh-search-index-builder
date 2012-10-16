class CommonsMembership < ActiveRecord::Base
  belongs_to :person
  has_many :commons_contributions, :class_name => "Contribution"
end