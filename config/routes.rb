# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :teams
get :edit_issue_team, :to => 'issue_team#edit'
