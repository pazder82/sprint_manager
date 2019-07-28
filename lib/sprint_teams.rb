require 'hooks/views_issues_hook'
require 'hooks/controller_issue_hook'
require 'patches/issue_patch'

module SprintTeams

  DUMMY ||= 10

  class << self
    def teams_values
      Team.all.each do |team|
        team.team
      end
    end
  end

end
