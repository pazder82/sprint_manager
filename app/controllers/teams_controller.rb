class TeamsController < ApplicationController
#  before_action :authorize_global, except: [:index, :show]

  def index
    @teams = Team.all
  end

  def create
    if Setting[:plugin_sprint_manager][:sprint_teams_managers].include?(User.current.login)
      @team = Team.new(team_params)
      if @team.save
        redirect_to @team
      else
        render 'new'
      end
    else
      redirect_to teams_path
    end
  end

  def new
    if Setting[:plugin_sprint_manager][:sprint_teams_managers].include?(User.current.login)
      @team = Team.new
    else
      redirect_to teams_path
    end
  end

  def edit
    if Setting[:plugin_sprint_manager][:sprint_teams_managers].include?(User.current.login)
      @team = Team.find(params[:id])
    else
      redirect_to teams_path
    end
  end

  def show
    @team = Team.find(params[:id])
  end

  def update
    if Setting[:plugin_sprint_manager][:sprint_teams_managers].include?(User.current.login)
      @team = Team.find(params[:id])
      if @team.update(team_params)
        redirect_to @team
      else
        render 'edit'
      end
    else
      redirect_to teams_path
    end
  end

  def destroy
    if Setting[:plugin_sprint_manager][:sprint_teams_managers].include?(User.current.login)
      @team = Team.find(params[:id])
      @team.destroy
    end
    redirect_to teams_path
  end

  private
    def team_params
      params.require(:team).permit(:team, :sprint)
    end
end
