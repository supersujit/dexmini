# frozen_string_literal: true

# Model to hold the robot scan data
class RobotScan < Scan
  validates :file, attached: true, content_type: ['application/json']
end
