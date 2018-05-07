class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.text :emotion
      t.text :sentiment

      t.timestamps
    end
    add_index("teams","id")
  end
end
