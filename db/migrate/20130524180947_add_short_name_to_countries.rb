class AddShortNameToCountries < ActiveRecord::Migration
  def up
  	system "rake fill_countries_and_states &"
  end

  def down
  	remove_column :countries, :shortname
  end
end
