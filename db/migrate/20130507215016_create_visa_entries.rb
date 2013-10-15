class CreateVisaEntries < ActiveRecord::Migration
  def up
    create_table :visa_entries do |t|
    	t.references :passport_visa

    	t.string :type_of_entry
    	t.integer :maximum_validity
    	t.integer :embassy_fees
    	t.integer :service_fees
    	t.integer :processing_time

      t.timestamps
    end
  end

  def down
  	drop_table :visa_entries
  end
end
