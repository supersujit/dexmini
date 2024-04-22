# frozen_string_literal: true

# Service to process the robot scans data
class RobotScansProcessor
  def initialize(scan_id)
    @scan = RobotScan.find(scan_id)
  end

  def process
    location_scans = []
    robot_scan = @scan.file.download
    scan_data = JSON.parse(robot_scan)
    scan_data.each do |scan_datum|
      location_scans << { location_name: scan_datum['name'], is_scanned: scan_datum['scanned'],
                          is_occupied: scan_datum['occupied'],
                          barcode: scan_datum.dig('detected_barcodes', 0), scan_id: @scan.id, created_at: Time.zone.now,
                          updated_at: Time.zone.now }
    end
    LocationScan.insert_all(location_scans)
  end
end
