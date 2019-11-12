class IssueTeamController < ApplicationController
  unloadable

  before_action :find_issues, :only => [:update]

  def update
    @issue_ids = params[:ids]
    @team_id = params[:team_id] if params[:team_id]
    @sprint = params[:sprint] if params[:sprint]
    @issue_ids.each do |issue_id|
      issue_teams_datum = IssueTeamsDatum.find_by('issue_id' => issue_id)
      if issue_teams_datum && @team_id == "0"
        # Team is (No team), destroy the record
        issue_teams_datum.destroy
      else
        if @team_id.to_i > 0 # Team is selected
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
          elsif @sprint == "no"
            issue_teams_datum[:sprint] = nil
          end
        end
        issue_teams_datum.save
        flash[:notice] = l(:notice_successful_update)
      end
    end
    redirect_to_referer_or { render :text => 'Team sprint updated.', :layout => true }
  end

  def getTeamSprint(team_id)
    team = Team.find_by('id' => team_id)
    team.sprint
  end

end
