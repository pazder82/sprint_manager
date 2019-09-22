class IssueTeamsDatum < ActiveRecord::Base
  belongs_to :team
  has_one :issue
end
