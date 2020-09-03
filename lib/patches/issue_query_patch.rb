# This file is a part of Redmin Agile (redmine_agile) plugin,
# Agile board plugin for redmine
#
# Copyright (C) 2011-2019 RedmineUP
# http://www.redmineup.com/
#
# redmine_agile is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_agile is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_agile.  If not, see <http://www.gnu.org/licenses/>.

require_dependency 'issue'

module SprintTeams
  module Patches

    module IssueQueryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :statement_without_sprint_teams, :statement
          alias_method :statement, :statement_with_sprint_teams

          alias_method :available_filters_without_sprint_teams, :available_filters
          alias_method :available_filters, :available_filters_with_sprint_teams

          available_columns << QueryColumn.new(:team, :caption => :label_team)#, :sortable => "#{Team.table_name}.team")
          available_columns << QueryColumn.new(:issue_sprint, :caption => :label_sprint)#, :sortable => "#{IssueTeamsDatum.table_name}.sprint")
        end
      end

      module InstanceMethods

        def statement_with_sprint_teams
          filter_teams  = filters.delete 'issue_teams'
          filter_sprints  = filters.delete 'issue_sprints'
          clauses = statement_without_sprint_teams || ''

          if filter_teams
            filters['issue_teams'] = filter_teams
            op = operator_for('issue_teams')
            if op.include?('!')
              compare = 'NOT IN'
              empty_ids_clause = 'TRUE'
            else
              compare = 'IN'
              empty_ids_clause = 'FALSE'
            end
            clauses << ' AND ' unless clauses.empty?
            issue_ids = IssueTeamsDatum.where(team_id: values_for('issue_teams')) # find issue ids with this team assigned
            if issue_ids.any?
              clauses << "( #{Issue.table_name}.id #{compare} (#{issue_ids.map(&:issue_id).join(',')}) ) "
            else
              # no issue ids found for this team
              clauses << empty_ids_clause
            end
          end

          if filter_sprints
            filters['issue_sprints'] = filter_sprints
            issue_ids = ''
            sprint_values = values_for('issue_sprints')
            op = operator_for('issue_sprints')

            if sprint_values.any?
              if op == '='
                #is
                issue_ids = IssueTeamsDatum.where(sprint: sprint_values[0]) # find issue ids with this sprint assigned
              elsif op == '>='
                #>=
                issue_ids = IssueTeamsDatum.where('sprint >= ?', sprint_values[0])
              elsif op == '<='
                #<=
                issue_ids = IssueTeamsDatum.where('sprint <= ?', sprint_values[0])
              elsif op == '><'
                #between
                issue_ids = IssueTeamsDatum.where('sprint > ?', sprint_values[0]).where('sprint < ?', sprint_values[1])
              elsif op == '!*'
                #none
                issue_ids = IssueTeamsDatum.where("sprint IS NULL")
              else
                #any
                issue_ids = IssueTeamsDatum.where("sprint IS NOT NULL")
              end
            end

            clauses << ' AND ' unless clauses.empty?
            if issue_ids.any?
              clauses << "( #{Issue.table_name}.id IN (#{issue_ids.map(&:issue_id).join(',')}) ) "
            else
              # no issue ids found for this team
              clauses << 'FALSE'
            end
            #binding.pry
          end
          clauses
        end

        def available_filters_with_sprint_teams
          available_filters_without_sprint_teams
          teams_list = Team.all.map { |c| [ c.team, c.id.to_s ] }
          add_available_filter('issue_teams', type: :list, name: l(:filter_team), values: teams_list)
          add_available_filter('issue_sprints', type: :integer, name: l(:filter_sprint))
        end
      end
    end

  end
end

unless IssueQuery.included_modules.include?(SprintTeams::Patches::IssueQueryPatch)
  IssueQuery.send(:include, SprintTeams::Patches::IssueQueryPatch)
end
