# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComparisonReportResult, type: :model do
  fixtures :comparison_reports, :comparison_report_results

  let(:result) { comparison_report_results(:result1) }

  describe 'description' do
    it 'gives the display string based on status' do
      result.status = 'match'
      expect(result.description).to eq('The location was occupied by the expected items')

      result.status = 'expectedly_empty'
      expect(result.description).to eq('The location was empty, as expected')

      result.status = 'unidentified_barcode'
      expect(result.description).to eq('The location was occupied, but no barcode could be identified')

      result.status = 'unexpectedly_empty'
      expect(result.description).to eq('The location was empty, but it should have been occupied')

      result.status = 'unexpectedly_occupied'
      expect(result.description).to eq('The location was occupied by an item, but should have been empty')

      result.status = 'items_mismatch'
      expect(result.description).to eq('The location was occupied by the wrong items')

      result.status = 'unknown'
      expect(result.description).to eq('Unknown')
    end
  end

  describe 'to_csv' do
    it 'returns a CSV string' do
      csv = ComparisonReportResult.to_csv
      expect(csv).to be_a(String)
      expect(csv).to include('location_name,is_scanned,is_occupied,expected_barcode,actual_barcode,status,description')
      expect(csv).to include('test_location,true,true,test_barcode,test_barcode,match,The location was occupied by the expected items')
    end
  end
end
