class CreatePassportVisas < ActiveRecord::Migration
  def up
    create_table :passport_visas do |t|
      t.references :country
      t.string :citizenship
      t.string :visa_type
      t.string :visa_required
      t.integer :maximum_stay
      
      t.text :travel_warnings
      t.text :requirements

      t.timestamps
    end
  end

  def down
    drop_table :passport_visas
  end
end
