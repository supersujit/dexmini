# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ManualScansProcessor do
  fixtures :scans
  let(:scan) { scans(:two) }

  describe '#process' do
    context 'when valid file is passed' do
      it 'creates a new location scan' do
        scan.update(file: fixture_file_upload('manual_scan.csv', 'text/csv'))
        expect { ManualScansProcessor.new(scan.id).process }.to change(LocationScan, :count).by(2)
      end
    end

    context 'when invalid file is passed' do
      it 'raises json parsing exception' do
        scan.update(file: fixture_file_upload('invalid_manual_scan.csv', 'text/csv'))
        expect { ManualScansProcessor.new(scan.id).process }.to change(LocationScan, :count).by(0)
      end
    end
  end
end
