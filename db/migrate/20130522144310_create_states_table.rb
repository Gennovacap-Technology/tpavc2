class CreateStatesTable < ActiveRecord::Migration
  def up
  	create_table :states do |t|
  		t.references :countries
  		t.column :name, :string, :size => 80
  		t.column :iso, :string, :size => 2
  	end
  end

  def down
  	drop_table :states
  end
end
