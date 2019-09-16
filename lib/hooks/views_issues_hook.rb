module SprintTeams
  module Hooks
    class ViewsIssuesHook < Redmine::Hook::ViewListener
      render_on :view_issues_form_details_bottom, :partial => "issues/teams_data_fields"
      render_on :view_issues_show_details_bottom, :partial => "issues/issue_sprint_team"
      render_on :view_issues_bulk_edit_details_bottom, :partial => "issues/teams_data_fields"
    end
  end
end

