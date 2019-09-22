#require 'pry'
require_dependency 'issue'

module SprintTeams
  module Patches

    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          #has_one :team, :dependent => :destroy
          has_one :issue_teams_datum, :dependent => :destroy
         end
      end

      module InstanceMethods
        def team
          if r = get_team_relation
            r.team
          end
        end

        def team_id
          if r = get_team_relation
            r.id
          end
        end

        def team_sprint
          if r = get_team_relation
            r.sprint
          end
        end

        def team_sprints
          if r = Team.all
            r.to_json
          end
        end

        def issue_sprint
          if r = IssueTeamsDatum.find_by(issue_id: id)
            r.sprint
          end
        end

        def print_inspect
          binding.pry
        end

        private
          def get_team_relation
            return Team.joins('inner join issue_teams_data on teams.id = issue_teams_data.team_id').find_by('issue_teams_data.issue_id' => id)
          end
      end
    end
  end
end

unless Issue.included_modules.include?(SprintTeams::Patches::IssuePatch)
  Issue.send(:include, SprintTeams::Patches::IssuePatch)
end
