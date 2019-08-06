class IssueTeamsDatum < ActiveRecord::Base
  belongs_to :team
  belongs_to :issue
end
