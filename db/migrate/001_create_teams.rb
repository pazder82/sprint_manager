class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :team
      t.integer :sprint
    end

    add_index :teams, :team
  end
end
