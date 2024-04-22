# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RobotScan, type: :model do
  fixtures :scans

  let(:scan) { scans(:one) }

  describe 'callbacks' do
    it 'enqueues a job to process the file after commit' do
      allow(ProcessScannedFileJob).to receive(:perform_async)
      scan = RobotScan.create(file: fixture_file_upload('robot_scan.json', 'application/json'))
      expect(ProcessScannedFileJob).to have_received(:perform_async).with(scan.id)
    end
  end
end
