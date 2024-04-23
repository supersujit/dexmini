# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RobotScansProcessor do
  fixtures :robot_scans
  let(:scan) { robot_scans(:robot_scan1) }

  describe '#process' do
    context 'when valid file is passed' do
      it 'creates a new location scan' do
        scan.update(file: fixture_file_upload('robot_scan.json', 'application/json'))
        expect { RobotScansProcessor.new(scan.id).process }.to change(LocationScan, :count).by(2)
      end
    end

    context 'when invalid file is passed' do
      it 'raises json parsing exception' do
        scan.update(file: fixture_file_upload('invalid_robot_scan.json', 'application/json'))
        expect { RobotScansProcessor.new(scan.id).process }.to raise_error(JSON::ParserError)
      end
    end

    context 'when file is passed with missing data' do
      it 'creates location data without barcode entries' do
        scan.update(file: fixture_file_upload('robot_scan_with_barcode_missing.json', 'application/json'))
        expect { RobotScansProcessor.new(scan.id).process }.to change(LocationScan, :count).by(1)
        expect(LocationScan.last.barcode).to be_nil
      end
    end
  end
end
