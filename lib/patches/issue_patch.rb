#require 'pry'
require_dependency 'issue'
require_dependency 'sprint_teams'

module SprintTeams
  module Patches

    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          has_one :teams, :dependent => :destroy
         end
      end

      module InstanceMethods
        def team
          if r = get_team_relation
            r.team
          end
          #binding.pry
        end

        def sprint
          if r = get_team_relation
            r.sprint
          end
        end

        private
          def get_team_relation
            return Team.joins('inner join teams_relations on teams.id = teams_relations.teams_id').find_by('teams_relations.issues_id' => id)
          end
      end
    end
  end
end

unless Issue.included_modules.include?(SprintTeams::Patches::IssuePatch)
  Issue.send(:include, SprintTeams::Patches::IssuePatch)
end
