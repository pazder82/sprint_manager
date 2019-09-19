module SprintTeams
  module Hooks
    class ControllerIssueHook < Redmine::Hook::ViewListener
      def controller_issues_bulk_edit_before_save(context={})
        save_sprint_teams_values(context)
      end

      def controller_issues_edit_after_save(context={})
        save_sprint_teams_values(context)
      end

      def save_sprint_teams_values(context)
        # Current SprintTeam values for this issue
        old_value = Issue.find(context[:issue].id)
        old_team_id = old_value.team_id.to_s
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
        changed = false
        new_value = IssueTeamsDatum.find_by('issues_id' => context[:issue].id)
        if !new_value
          # Not yet existing in table - create new row
          new_value = IssueTeamsDatum.new
          new_value[:issues_id] = context[:issue].id
        end
        if (new_team_id != old_team_id)
          new_value[:teams_id] = (new_team_id.blank? ? nil : new_team_id.to_i)
          changed = true
        end
        if (new_issue_sprint != old_issue_sprint)
          new_value[:sprint] = (new_issue_sprint.blank? ? nil : new_issue_sprint.to_i)
          changed = true
        end

        if changed
          if (new_issue_sprint.blank? && new_team_id.blank?)
            # All values have been cleared - remove row
            new_value.destroy
          else
            # Update row
            new_value.save
          end
        end
      end
    end
  end
end
