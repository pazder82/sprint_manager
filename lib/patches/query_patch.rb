require_dependency 'query'
if ActiveSupport::Dependencies::search_for_file('issue_query')
  require_dependency 'issue_query'
end

module SprintTeams
  module Patches
    module QueryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          alias_method :statement_without_sprint_teams, :statement
          alias_method :statement, :statement_with_sprint_teams

          alias_method :available_filters_without_sprint_teams, :available_filters
          alias_method :available_filters, :available_filters_with_sprint_teams

          #add_available_column QueryTagsColumn.new(:teams_relations, caption: :teams)
        end
      end

      module InstanceMethods
        def statement_with_sprint_teams
          filter  = filters.delete 'issue_teams'
          clauses = statement_without_sprint_teams || ''

          if filter
            filters['issue_teams'] = filter
            op = operator_for('issue_teams')
            if op.include?('!')
              compare = 'NOT IN'
              empty_ids_clause = 'TRUE'
            else
              compare = 'IN'
              empty_ids_clause = 'FALSE'
            end

            clauses << ' AND ' unless clauses.empty?
            issue_ids = IssueTeamsDatum.where(teams_id: values_for('issue_teams')) # find issue ids with this team assigned
            if issue_ids.any?
              clauses << "( #{Issue.table_name}.id #{compare} (#{issue_ids.map(&:issues_id).join(',')}) ) "
            else
              # no issue ids found for this team
              clauses << empty_ids_clause
            end
            #binding.pry
          end

          clauses
        end

        def available_filters_with_sprint_teams
          available_filters_without_sprint_teams
          teams_list = Team.all.map { |c| [ c.team, c.id ] }
          add_available_filter('issue_teams', type: :list, name: l(:filter_team), values: teams_list)
        end
      end
    end
  end
end

unless Query.included_modules.include?(SprintTeams::Patches::QueryPatch)
  Query.send(:include, SprintTeams::Patches::QueryPatch)
end
