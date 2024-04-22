# frozen_string_literal: true

# Controller to handle the comparison reports
class ComparisonReportResult < ApplicationRecord
  require 'csv'
  belongs_to :comparison_report
  enum status: { unknown: 0, match: 1, expectedly_empty: 2, unidentified_barcode: 3, unexpectedly_empty: 4,
                 unexpectedly_occupied: 5, items_mismatch: 6 }

  def description
    case status.to_sym
    when :match
      'The location was occupied by the expected items'
    when :expectedly_empty
      'The location was empty, as expected'
    when :unidentified_barcode
      'The location was occupied, but no barcode could be identified'
    when :unexpectedly_empty
      'The location was empty, but it should have been occupied'
    when :unexpectedly_occupied
      'The location was occupied by an item, but should have been empty'
    when :items_mismatch
      'The location was occupied by the wrong items'
    else
      'Unknown'
    end
  end

  def self.to_csv
    attributes = %w[location_name is_scanned is_occupied expected_barcode actual_barcode status description]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |result|
        csv << attributes.map { |attr| result.send(attr) }
      end
    end
  end
end
