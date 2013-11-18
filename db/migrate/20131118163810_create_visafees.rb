class CreateVisafees < ActiveRecord::Migration
  def up
    create_table :visafees do |t|
      t.references :visa_entry
      
      t.integer :embassy_fees
      t.integer :service_fees
      t.integer :processing_time_from
      t.integer :processing_time_to

      t.timestamps
    end
    change_table :visa_entries do |t|
      t.remove :embassy_fees, :service_fees, :processing_time
    end
  end

  def down
  	drop_table :visafees
    add_column :visa_entries, :embassy_fees, :integer
    add_column :visa_entries, :service_fees, :integer
    add_column :visa_entries, :processing_time, :integer
  end
end
