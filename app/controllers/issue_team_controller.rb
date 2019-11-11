class IssueTeamController < ApplicationController
  unloadable

  before_action :find_issues, :only => [:edit]

  def edit
    @issue_ids = params[:ids]
    @team_id = params[:team_id] if params[:team_id]
    @sprint = params[:sprint] if params[:sprint]
    @issue_ids.each do |issue_id|
      issue_teams_datum = IssueTeamsDatum.find_by('issue_id' => issue_id)
      if @team_id
        if !issue_teams_datum
          # Not yet existing in table - create new row
          issue_teams_datum = IssueTeamsDatum.new
          issue_teams_datum[:issue_id] = issue_id
        end
        issue_teams_datum[:team_id] = @team_id
      end
      if issue_teams_datum
        if @sprint == "current"
          issue_teams_datum[:sprint] = getTeamSprint(issue_teams_datum[:team_id])
        elsif @sprint == "next"
          issue_teams_datum[:sprint] = getTeamSprint(issue_teams_datum[:team_id])+1
        end
        issue_teams_datum.save
      end
    end
    redirect_to :back
  end

  def getTeamSprint(team_id)
    # FIXME:
    11
  end

end
