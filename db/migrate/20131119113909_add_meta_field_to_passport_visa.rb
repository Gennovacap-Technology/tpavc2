class AddMetaFieldToPassportVisa < ActiveRecord::Migration
  def up
  	add_column :passport_visas, :meta_title, :string
  	add_column :passport_visas, :meta_description, :string
  	add_column :passport_visas, :meta_keywords, :string
  end

  def down
  	change_table :passport_visas do |t|
  		t.remove :meta_title, :meta_keywords, :meta_description
  	end
  end
end
