class ChangeIssueTeamsData < ActiveRecord::Migration[4.2]
  def change
    change_table :issue_teams_data do |t|
      t.rename :teams_id, :team_id
      t.rename :issues_id, :issue_id
#      t.belongs_to :team, null: false, foreign_key: true
#      t.belongs_to :issue, null: false, foreign_key: true
    end
  end
end
