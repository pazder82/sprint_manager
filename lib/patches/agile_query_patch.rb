if Redmine::Plugin.installed?(:redmine_agile) &&
   Gem::Version.new(Redmine::Plugin.find(:redmine_agile).version) >= Gem::Version.new('1.4.3')

  module SprintTeams
    module Patches

      module AgileQueryPatch
        def self.included(base)
          base.send(:include, InstanceMethods)
          base.class_eval do
            unloadable

            alias_method :available_filters_without_sprint_teams, :available_filters
            alias_method :available_filters, :available_filters_with_sprint_teams

            available_columns << QueryColumn.new(:team, :caption => :label_team)#, :sortable => "#{Team.table_name}.team")
            available_columns << QueryColumn.new(:issue_sprint, :caption => :label_sprint)#, :sortable => "#{IssueTeamsDatum.table_name}.sprint")
          end
        end

        module InstanceMethods
          def sql_for_issue_teams_field(_field, operator, value)
              if operator.include?('!')
                compare = 'NOT IN'
                empty_ids_clause = 'TRUE'
              else
                compare = 'IN'
                empty_ids_clause = 'FALSE'
              end
              issue_ids = IssueTeamsDatum.where(team_id: value.clone) # find issue ids with this team assigned
              if issue_ids.any?
                "( #{Issue.table_name}.id #{compare} (#{issue_ids.map(&:issue_id).join(',')}) ) "
              else
                # no issue ids found for this team
                empty_ids_clause
              end
          end

          def sql_for_issue_sprints_field(_field, operator, value)
              issue_ids = ''
              if operator == '='
                #is
                issue_ids = IssueTeamsDatum.where(sprint: value[0]) # find issue ids with this sprint assigned
              elsif operator == '>='
                #>=
                issue_ids = IssueTeamsDatum.where('sprint >= ?', value[0])
              elsif operator == '<='
                #<=
                issue_ids = IssueTeamsDatum.where('sprint <= ?', value[0])
              elsif operator == '><'
                #between
                issue_ids = IssueTeamsDatum.where('sprint > ?', value[0]).where('sprint < ?', value[1])
              elsif operator == '!*'
                #none
                issue_ids = IssueTeamsDatum.where("sprint IS NULL")
              else
                #any
                issue_ids = IssueTeamsDatum.where("sprint IS NOT NULL")
              end
              if issue_ids.any?
                "( #{Issue.table_name}.id IN (#{issue_ids.map(&:issue_id).join(',')}) ) "
              else
                # no issue ids found for this team
                'FALSE'
              end
          end

          def available_filters_with_sprint_teams
            available_filters_without_sprint_teams

            teams_list = Team.all.map { |c| [ c.team, c.id.to_s ] }
            add_available_filter('issue_teams', type: :list, name: l(:filter_team), values: teams_list)
            add_available_filter('issue_sprints', type: :integer, name: l(:filter_sprint))
            #binding.pry
          end
        end
      end
    end
  end

  unless AgileQuery.included_modules.include?(SprintTeams::Patches::AgileQueryPatch)
    AgileQuery.send(:include, SprintTeams::Patches::AgileQueryPatch)
  end

end
