Redmine::Plugin.register :sprint_manager do
  name 'Sprint Manager plugin'
  author 'Jan Pazdera '
  description 'This plugin introduces, sprints, sprint teams and tools for their easy management.'
  version '0.0.1'
  url 'http://www.flowmon.com'
  author_url 'http://www.flowmon.com'

  menu :application_menu, :teams, { :controller => 'teams', :action => 'index' }, :caption => 'Sprint Teams'
end
