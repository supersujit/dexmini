# frozen_string_literal: true

# Job to process the scanned file
class ProcessScannedFileJob
  include Sidekiq::Job
  sidekiq_options retry: false

  def perform(scan_id)
    scan = Scan.find(scan_id)
    return if scan.processing?

    scan.processing!
    RobotScansProcessor.new(scan_id).process
    scan.completed!
  rescue JSON::ParserError
    scan.failed!
  end
end
