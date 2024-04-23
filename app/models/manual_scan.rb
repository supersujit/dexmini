# frozen_string_literal: true

# Model to hold the manual scan data
class ManualScan < Scan
  validates :file, attached: true, content_type: ['text/csv']
end
