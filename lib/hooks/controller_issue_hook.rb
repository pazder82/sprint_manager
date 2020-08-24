module SprintTeams
  module Hooks
    class ControllerIssueHook < Redmine::Hook::ViewListener
      def controller_issues_bulk_edit_before_save(context={})
        save_sprint_teams_values(context)
      end

      def controller_issues_new_after_save(context={})
        save_sprint_teams_values(context)
      end

      def controller_issues_edit_before_save(context={})
        save_sprint_teams_values(context)
      end

      def save_sprint_teams_values(context)
        # Current SprintTeam values for this issue
        old_value = Issue.find(context[:issue].id)
        old_team_id = old_value.team_id.to_s
        old_team = Team.find_by(id: old_team_id)
        old_team_name = nil
        if !old_team.blank?
          old_team_name = old_team.team
        end
        old_issue_sprint = old_value.issue_sprint.to_s

        # New SprintTeam values inserted by user
        new_team_id = context[:params][:issue_teams_data][:team] if context[:params][:issue_teams_data]
        if new_team_id.blank?
          if context[:params][:action] == "bulk_update"
            new_team_id = old_team_id
          else
            new_team_id = nil
          end
        end

        new_team_name = nil
        if !new_team_id.blank?
          new_team = Team.find_by(id: new_team_id)
          new_team_name = new_team.team if !new_team.blank?
        end

        new_issue_sprint = context[:params][:issue_teams_data][:sprint] if context[:params][:issue_teams_data]
        if new_issue_sprint.blank?
          if context[:params][:action] == "bulk_update"
            new_issue_sprint = old_issue_sprint
          else
            new_issue_sprint = nil
          end
        end
        new_issue_sprint = nil if new_team_id.blank?

        # Update model
        team_changed = false
        sprint_changed = false
        new_value = IssueTeamsDatum.find_by('issue_id' => context[:issue].id)
        if !new_value
          # Not yet existing in table - create new row
          new_value = IssueTeamsDatum.new
          new_value[:issue_id] = context[:issue].id
        end
        if (new_team_id != old_team_id) && !(new_team_id.blank? && old_team_name.blank?)
          new_value[:team_id] = (new_team_id.blank? ? nil : new_team_id.to_i)
          team_changed = true
        end
        if (new_issue_sprint != old_issue_sprint) && !(new_issue_sprint.blank? && old_issue_sprint.blank?)
          new_value[:sprint] = (new_issue_sprint.blank? ? nil : new_issue_sprint.to_i)
          sprint_changed = true
        end

        if team_changed || sprint_changed
          if (new_issue_sprint.blank? && new_team_id.blank?)
            # All values have been cleared - remove row
            new_value.destroy
          else
            # Update row
            new_value.save
          end

          # Create record into journal
          issue = context[:issue]
          if !issue.blank? && !issue.current_journal.blank?
            if (new_team_id != old_team_id) && team_changed
              issue.current_journal.details << JournalDetail.new(property: 'attr',
                                                               prop_key: 'journal_team',
                                                               old_value: old_team_name,
                                                               value: new_team_name)
            end
            if (new_issue_sprint != old_issue_sprint) && sprint_changed
              issue.current_journal.details << JournalDetail.new(property: 'attr',
                                                               prop_key: 'journal_sprint',
                                                               old_value: old_issue_sprint,
                                                               value: new_issue_sprint)
            end
          end
        end
      end

    end
  end
end
