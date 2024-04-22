class CreateScans < ActiveRecord::Migration[6.1]
  def change
    create_table :scans do |t|
      t.string :type
      t.string :filename
      t.integer :status

      t.timestamps
    end
  end
end
