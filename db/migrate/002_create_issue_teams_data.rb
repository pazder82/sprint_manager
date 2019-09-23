class CreateIssueTeamsData < ActiveRecord::Migration
  def change
    create_table :issue_teams_data do |t|
      t.belongs_to :teams, null: false
      t.belongs_to :issues, null: false
      t.integer :sprint
    end
    add_foreign_key :issue_teams_data, :issues, { on_delete: :cascade, column: :issues_id }
    add_foreign_key :issue_teams_data, :teams, { on_delete: :cascade, column: :teams_id }
  end
end
