
require 'hooks/views_issues_hook'
require 'hooks/controller_issue_hook'
require 'patches/issue_patch'
require 'patches/query_patch'

module SprintTeams

  DUMMY ||= 10

  class << self
    def teams_values
      Team.find_each do |team|
        team.team
      end
    end
  end

end
