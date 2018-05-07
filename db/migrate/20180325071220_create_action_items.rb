class CreateActionItems < ActiveRecord::Migration[5.1]
  def up
    create_table :action_items do |t|
      t.string :content
      t.string :emotion
      t.string :sentiment
      t.integer :user_id
      t.integer :team_id
      t.timestamps
    end
    add_index("action_items","id")
  end

  def down
  	drop_table :action_items do |t|
  	end
  end

end
