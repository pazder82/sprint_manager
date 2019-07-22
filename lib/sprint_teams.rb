require 'hooks/views_issues_hook'
require 'patches/issue_patch'

module SprintTeams

  DUMMY ||= 10

  class << self
    def teams_values
      Team.all.each do |team|
        team.team
      end
      #Setting.plugin_redmine_agile['sp_values'].to_s.split(',').map{|x| x.strip.to_i}.uniq.delete_if{|x| x == 0}
    end
  end

end
