# frozen_string_literal: true

# Job to process the comparison report
class ProcessComparisonReportJob
  include Sidekiq::Job
  sidekiq_options retry: 0

  def perform(report_id)
    report = ComparisonReport.find(report_id)
    return if report.processing?

    report.processing!
    populate_manual_scan_data(report.manual_scan)
    ComparisonReportGenerator.new(report_id).generate
    report.completed!
  end

  private

  def populate_manual_scan_data(manual_scan)
    manual_scan.processing!
    ManualScansProcessor.new(manual_scan.id).process
    manual_scan.completed!
  end
end
