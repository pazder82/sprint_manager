class CreateTeams < ActiveRecord::Migration[4.2]
  def change
    create_table :teams do |t|
      t.string :team, index: true, null: false
      t.integer :sprint
    end

  end
end
