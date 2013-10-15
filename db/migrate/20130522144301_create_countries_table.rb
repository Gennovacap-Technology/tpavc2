class CreateCountriesTable < ActiveRecord::Migration
  def up
  	create_table :countries do |t|
  		t.column :iso, :string, :size => 2
  		t.column :name, :string, :size => 80
  		t.column :shortname, :string, :size => 4
  	end
  end

  def down
  	drop_table :countries
  end
end