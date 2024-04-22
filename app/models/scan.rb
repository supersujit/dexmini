# frozen_string_literal: true

# Model to hold the base scan object. The type of scan can be robot or manual
class Scan < ApplicationRecord
  has_one_attached :file
  has_many :location_scans

  validates :file, presence: true
  enum status: { created: 0, processing: 1, completed: 2, failed: 3 }
end
