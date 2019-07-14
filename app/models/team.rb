class Team < ActiveRecord::Base
  validates :team, presence: true
  validates :sprint, numericality: { only_integer: true, allow_nil: true, greater_than: 0 }
end
