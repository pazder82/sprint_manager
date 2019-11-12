# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :teams
get :update_issue_team, :to => 'issue_team#update'
