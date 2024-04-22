class CreateComparisonReportResults < ActiveRecord::Migration[6.1]
  def change
    create_table :comparison_report_results do |t|
      t.references :comparison_report, null: false, foreign_key: true
      t.string :location_name
      t.boolean :is_scanned
      t.boolean :is_occupied
      t.string :expected_barcode
      t.string :actual_barcode
      t.integer :status

      t.timestamps
    end
  end
end
