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

          add_available_column QueryTagsColumn.new(:teams_relations, caption: :teams)
        end
      end

      class QueryTagsColumn < QueryColumn
        def css_classes; 'teams' end
      end

      module InstanceMethods
        def statement_with_sprint_teams
          filter  = filters.delete 'issue_teams'
          clauses = statement_without_sprint_teams || ''

          if filter
            filters['issue_teams'] = filter

            issues = Issue.where({})

            op = operator_for('issue_teams')
            case op
            when '=', '!'
              issues = issues.tagged_with(values_for('issue_teams').clone)
            when '!*'
              issues = issues.joins(:teams).uniq
            else
              issues = issues.tagged_with(RedmineCrm::Tag.all.map(&:to_s), :any => true)
            end

            compare   = op.include?('!') ? 'NOT IN' : 'IN'
            ids_list  = issues.collect(&:id).push(0).join(',')

            clauses << ' AND ' unless clauses.empty?
            clauses << "( #{Issue.table_name}.id #{compare} (#{ids_list}) ) "
            #binding.pry
          end

          clauses
        end

        def available_filters_with_sprint_teams
          available_filters_without_sprint_teams
          teams_list = []
          teams_list = [["Bug", "1"], ["Feature", "2"], ["Support", "3"]]
          #if filters['issue_tags'].present?
          #  selected_tags = Issue.all_tags(:project => project, :open_only => RedmineTags.settings['issues_open_only'].to_i == 1).
          #      where(:name => filters['issue_tags'][:values]).map { |c| [c.name, c.name] }
          #end
          add_available_filter('issue_teams', type: :list, name: l(:filter_team), values: teams_list)
        end
      end
    end
  end
end

unless Query.included_modules.include?(SprintTeams::Patches::QueryPatch)
  Query.send(:include, SprintTeams::Patches::QueryPatch)
end
