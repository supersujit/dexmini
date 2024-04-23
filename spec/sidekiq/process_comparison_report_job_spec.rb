# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ProcessComparisonReportJob, type: :job do
  fixtures :comparison_reports, :location_scans
  let(:comparison_report) { comparison_reports(:report1) }
  let(:robot_location_scan) { location_scans(:robot_location_scan1) }
  let(:manual_location_scan) { location_scans(:manual_location_scan1) }

  before do
    robot_location_scan.update!(scan: comparison_report.robot_scan)
    manual_location_scan.update!(scan: comparison_report.manual_scan)
    comparison_report.manual_scan.update(file: fixture_file_upload('manual_scan.csv', 'text/csv'))

    allow(ManualScansProcessor).to receive(:new).and_return(double('ManualScansProcessor', process: true))
    allow(ComparisonReportGenerator).to receive(:new).and_return(double('ComparisonReportGenerator', generate: true))
  end

  context 'when report is already processing' do
    it 'does not process the report' do
      comparison_report.processing!
      ProcessComparisonReportJob.new.perform(comparison_report.id)
      expect(ComparisonReportGenerator).not_to have_received(:new)
    end
  end

  it 'populates the manual scan records' do
    ProcessComparisonReportJob.new.perform(comparison_report.id)
    expect(ManualScansProcessor).to have_received(:new).with(comparison_report.manual_scan.id)
  end

  it 'generates the comparison report' do
    ProcessComparisonReportJob.new.perform(comparison_report.id)
    expect(ComparisonReportGenerator).to have_received(:new).with(comparison_report.id)
  end

  it 'on completion marks the report as completed' do
    ProcessComparisonReportJob.new.perform(comparison_report.id)
    comparison_report.reload
    expect(comparison_report.completed?).to be(true)
  end

  it 'on completion marks the manual scan as completed' do
    ProcessComparisonReportJob.new.perform(comparison_report.id)
    comparison_report.manual_scan.reload
    expect(comparison_report.manual_scan.completed?).to be(true)
  end
end
