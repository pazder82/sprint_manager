Redmine::Plugin.register :sprint_manager do
  name 'Sprint Manager plugin'
  author 'Jan Pazdera '
  description 'This plugin introduces, sprints, sprint teams and tools for their easy management.'
  version '0.0.1'
  url 'http://www.flowmon.com'
  author_url 'http://www.flowmon.com'

  menu :application_menu, :teams, { :controller => 'teams', :action => 'index' },
      :caption => :label_teams,
      :after => :gantt

#  menu :project_menu, :teams, { :controller => 'teams', :action => 'index' },
#       :caption => :label_teams,
#       :after => :gantt,
#       :param => :project_id


  project_module :teams do
    permission :view_teams, {:teams => [:index, :show]}, :require => :loggedin
    permission :manage_teams, {:teams => [:new, :create, :edit, :update, :destroy]}, :require => :member
  end
end

require 'sprint_teams'
