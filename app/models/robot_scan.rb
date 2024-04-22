# frozen_string_literal: true

# Model to hold the robot scan data
class RobotScan < Scan
  validates :file, attached: true, content_type: ['application/json']

  after_commit :process_file, on: :create

  private

  def process_file
    ProcessScannedFileJob.perform_async(id)
  end
end
