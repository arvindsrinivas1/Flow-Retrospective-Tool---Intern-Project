class CreateMemberships < ActiveRecord::Migration[5.1]
  def up
    create_table :memberships do |t|
      t.integer :team_id
      t.integer :user_id
      t.string :role
      t.timestamps
    end
    add_index("memberships", ["team_id","user_id"])
  end

  def down
    drop_table :memberships do |t|
    end
  end  
end
