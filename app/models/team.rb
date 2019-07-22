class Team < ActiveRecord::Base
  has_one :issue_teams_data, :dependent => :destroy
  validates :team, presence: true
  validates :sprint, numericality: { only_integer: true, allow_nil: true, greater_than: 0 }
end
