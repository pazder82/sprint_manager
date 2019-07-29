class CreateIssueTeamsData < ActiveRecord::Migration[5.2]
  def change
    create_table :issue_teams_data do |t|
      t.belongs_to :teams, foreign_key: true, null: false
      t.belongs_to :issues, foreign_key: true, null: false
      t.integer :sprint
    end
  end
end
