# frozen_string_literal: true

# Service to compare the robot and manual scans and generate the report for the given report_id
class ComparisonReportGenerator
  def initialize(report_id)
    @report = ComparisonReport.find(report_id)
  end

  def generate
    populate_report_data
  end

  private

  def populate_report_data
    sql_query = <<~SQL
      insert into comparison_report_results (comparison_report_id, created_at, updated_at, location_name, is_scanned, is_occupied, expected_barcode, actual_barcode, status)
      select #{@report.id}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, man.location_name, robot.is_scanned, robot.is_occupied, man.barcode as man_barcode,
        robot.barcode as robot_barcode,#{comparison_conditions} as match_status
      from location_scans robot join location_scans man on robot.location_name = man.location_name
      where robot.scan_id = #{@report.robot_scan_id} and man.scan_id = #{@report.manual_scan_id};

      select CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, man.location_name, robot.is_scanned, robot.is_occupied, man.barcode as man_barcode, robot.barcode as robot_barcode from location_scans robot join location_scans man on robot.location_name = man.location_name where robot.scan_id = 131102202 and man.scan_id = 817056075
    SQL
    ActiveRecord::Base.connection.execute(sql_query)
  end

  def comparison_conditions
    <<~SQL
      CASE
           WHEN robot.is_occupied AND robot.barcode IS NULL
               THEN #{ComparisonReportResult.statuses['unidentified_barcode']}
           WHEN robot.barcode IS NULL AND man.barcode IS NULL
               THEN #{ComparisonReportResult.statuses['expectedly_empty']}
           WHEN robot.barcode IS NULL AND man.barcode IS NOT NULL
               THEN #{ComparisonReportResult.statuses['unexpectedly_empty']}
           WHEN robot.barcode IS NOT NULL AND man.barcode IS NULL
               THEN #{ComparisonReportResult.statuses['unexpectedly_occupied']}
           WHEN robot.barcode = man.barcode
               THEN #{ComparisonReportResult.statuses['match']}
           WHEN robot.barcode != man.barcode
               THEN #{ComparisonReportResult.statuses['items_mismatch']}
           ELSE #{ComparisonReportResult.statuses['unknown']}
        END
    SQL
  end
end
