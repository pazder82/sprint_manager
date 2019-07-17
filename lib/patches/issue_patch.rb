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
          @team ||= 'hopovcii'#teams.team
        end
      end
    end
  end
end

unless Issue.included_modules.include?(SprintTeams::Patches::IssuePatch)
  Issue.send(:include, SprintTeams::Patches::IssuePatch)
end
