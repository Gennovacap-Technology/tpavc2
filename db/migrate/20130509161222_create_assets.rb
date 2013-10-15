class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :passport_visa
      t.string :pdf_name
      t.string :pdf_real_name
      t.string :pdf_type
      t.timestamps
    end
    add_index :assets, :passport_visa_id
  end
end
