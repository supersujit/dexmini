# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComparisonReportGenerator do
  fixtures :robot_scans, :manual_scans, :comparison_reports, :location_scans

  let(:comparison_report) { comparison_reports(:report1) }
  let(:robot_location_scan) { location_scans(:robot_location_scan1) }
  let(:manual_location_scan) { location_scans(:manual_location_scan1) }

  before do
    robot_location_scan.update!(scan: comparison_report.robot_scan)
    manual_location_scan.update!(scan: comparison_report.manual_scan)
  end

  describe '#generate' do
    context 'when there are no entries' do
      before { LocationScan.destroy_all }
      it 'creates an empty result' do
        expect do
          ComparisonReportGenerator.new(comparison_report.id).generate
        end.to change(ComparisonReportResult, :count).by(0)
      end
    end

    context 'when robot scan has entries' do
      context 'with location was occupied as expected' do
        it 'creates a new result' do
          expect do
            ComparisonReportGenerator.new(comparison_report.id).generate
          end.to change(ComparisonReportResult, :count).by(1)
          generated_result = ComparisonReportResult.last
          expect(generated_result.status).to eq('match')
        end

        it 'populates all the result fields correctly' do
          ComparisonReportGenerator.new(comparison_report.id).generate
          generated_result = ComparisonReportResult.last
          expect(generated_result.location_name).to eq(robot_location_scan.location_name)
          expect(generated_result.is_scanned).to eq(robot_location_scan.is_scanned)
          expect(generated_result.is_occupied).to eq(true)
          expect(generated_result.expected_barcode).to eq(manual_location_scan.barcode)
          expect(generated_result.actual_barcode).to eq(robot_location_scan.barcode)
        end
      end

      context 'with location was empty as expected' do
        it 'creates a new result' do
          robot_location_scan.update!(is_occupied: false, barcode: nil)
          manual_location_scan.update!(barcode: nil)
          expect do
            ComparisonReportGenerator.new(comparison_report.id).generate
          end.to change(ComparisonReportResult, :count).by(1)
          generated_result = ComparisonReportResult.last
          expect(generated_result.status).to eq('expectedly_empty')
          expect(generated_result.is_occupied).to eq(false)
        end
      end

      context 'with location was empty unexpectedly' do
        it 'creates a new result' do
          robot_location_scan.update!(is_occupied: false, barcode: nil)
          expect do
            ComparisonReportGenerator.new(comparison_report.id).generate
          end.to change(ComparisonReportResult, :count).by(1)
          generated_result = ComparisonReportResult.last
          expect(generated_result.status).to eq('unexpectedly_empty')
          expect(generated_result.is_occupied).to eq(false)
        end
      end

      context 'with location was occupied unexpectedly' do
        it 'creates a new result' do
          manual_location_scan.update!(is_occupied: false, barcode: nil)
          expect do
            ComparisonReportGenerator.new(comparison_report.id).generate
          end.to change(ComparisonReportResult, :count).by(1)
          generated_result = ComparisonReportResult.last
          expect(generated_result.status).to eq('unexpectedly_occupied')
          expect(generated_result.is_occupied).to eq(true)
        end
      end

      context 'with location occupied by wrong item' do
        it 'creates a new result' do
          robot_location_scan.update!(barcode: 'wrong_item')
          expect do
            ComparisonReportGenerator.new(comparison_report.id).generate
          end.to change(ComparisonReportResult, :count).by(1)
          generated_result = ComparisonReportResult.last
          expect(generated_result.status).to eq('items_mismatch')
          expect(generated_result.is_occupied).to eq(true)
          expect(generated_result.expected_barcode).to eq(manual_location_scan.barcode)
          expect(generated_result.actual_barcode).to eq(robot_location_scan.barcode)
        end
      end

      context 'with no barcode scanned' do
        it 'creates a new result' do
          robot_location_scan.update!(barcode: nil)
          expect do
            ComparisonReportGenerator.new(comparison_report.id).generate
          end.to change(ComparisonReportResult, :count).by(1)
          generated_result = ComparisonReportResult.last
          expect(generated_result.status).to eq('unidentified_barcode')
          expect(generated_result.is_occupied).to eq(true)
          expect(generated_result.expected_barcode).to eq(manual_location_scan.barcode)
          expect(generated_result.actual_barcode).to eq(nil)
        end
      end
    end
  end
end
