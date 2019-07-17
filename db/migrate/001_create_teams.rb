class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :team, index: true
      t.integer :sprint
    end

    create_table :teams_relations do |t|
      t.belongs_to :teams, index: true
      t.belongs_to :issues, index: true
    end
  end
end
