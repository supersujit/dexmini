# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessScannedFileJob, type: :job do
  fixtures :robot_scans

  let(:scan) { robot_scans(:robot_scan1) }

  context 'when the file is valid json file' do
    before do
      scan.update(file: fixture_file_upload('robot_scan.json', 'application/json'))
    end

    it 'calls the processor service' do
      allow(RobotScansProcessor).to receive_message_chain(:new, :process)
      ProcessScannedFileJob.new.perform(scan.id)
      scan.reload
      expect(scan.completed?).to be(true)
      expect(RobotScansProcessor).to have_received(:new).with(scan.id)
    end
  end

  context 'when the file is not parsable' do
    before do
      scan.update(file: fixture_file_upload('invalid_robot_scan.json', 'application/json'))
    end

    it 'marks the scan as failed' do
      allow(RobotScansProcessor).to receive_message_chain(:new, :process).and_raise(JSON::ParserError)
      ProcessScannedFileJob.new.perform(scan.id)
      scan.reload
      expect(scan.failed?).to be(true)
    end
  end
end
