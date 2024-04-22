# frozen_string_literal: true

# Model to hold the scan data for each location. This model holds data for robot as well as manual scan
class LocationScan < ApplicationRecord
  belongs_to :scan
end
