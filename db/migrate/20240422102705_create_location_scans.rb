class CreateLocationScans < ActiveRecord::Migration[6.1]
  def change
    create_table :location_scans do |t|
      t.string :location_name, index: true
      t.boolean :is_scanned
      t.boolean :is_occupied
      t.string :barcode
      t.references :scan, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
