class CreateUsers < ActiveRecord::Migration[5.1]
  def up
    create_table :users do |t|
      t.string :name	
      #t.string :team_id
      #t.team_id :integer
      t.timestamps
    end
    add_index("users","id")
  end

  def down 
    drop_table :users do |t|
    end	
  end

end
