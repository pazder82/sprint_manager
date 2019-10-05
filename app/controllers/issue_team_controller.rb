class IssueTeamController < ApplicationController
  unloadable

  before_action :find_issues, :only => [:edit, :update]

  def edit
    @issue_ids = params[:ids]
    @is_bulk_editing = @issue_ids.size > 1
    @team_id = params[:team_id]
  end

  def update
    # FIXME:
    team = params[:issue]

    Issue.transaction do
      @issues.each do |issue|
        #issue.team = team
        issue.save!
      end
    end
    flash[:notice] = t(:notice_tags_added)
  rescue Exception => e
    puts e
    flash[:error] = t(:notice_failed_to_add_tags)
  ensure
    redirect_to_referer_or { render :text => 'Tags updated.', :layout => true }
  end
end
