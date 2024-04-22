# frozen_string_literal: true

# Model to store the Comparison Report data
class ComparisonReport < ApplicationRecord
  belongs_to :robot_scan
  belongs_to :manual_scan
  has_many :comparison_report_results, dependent: :destroy

  enum status: { pending: 0, processing: 1, completed: 2, failed: 3 }

  def still_processing?
    processing? || pending?
  end
end
