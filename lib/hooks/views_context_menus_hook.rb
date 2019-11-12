module SprintTeams
  module Hooks
    class ViewsContextMenuesHook < Redmine::Hook::ViewListener
      render_on :view_issues_context_menu_end, :partial => 'context_menus/issues_teams_sprints'
    end
  end
end
