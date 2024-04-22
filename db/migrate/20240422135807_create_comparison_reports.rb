# frozen_string_literal: true

class CreateComparisonReports < ActiveRecord::Migration[6.1]
  def change
    create_table :comparison_reports do |t|
      t.bigint :robot_scan_id
      t.bigint :manual_scan_id
      t.integer :status

      t.timestamps
    end
  end
end
