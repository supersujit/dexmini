# frozen_string_literal: true

# Service to process the manual scans
class ManualScansProcessor
  require 'csv'

  def initialize(scan_id)
    @scan = ManualScan.find(scan_id)
  end

  def process
    csv_file = @scan.file.download
    csv = CSV.parse(csv_file, headers: true)
    location_scans = []
    csv.each do |row|
      location_scans << { location_name: row['LOCATION'], is_scanned: true,
                          is_occupied: row['ITEM'] ? true : false, barcode: row['ITEM'],
                          scan_id: @scan.id, created_at: Time.zone.now, updated_at: Time.zone.now }
    end
    LocationScan.insert_all(location_scans) if location_scans.present?
  end
end
