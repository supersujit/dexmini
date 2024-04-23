# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComparisonReport, type: :model do
  fixtures :comparison_reports

  let(:report) { comparison_reports(:report1) }

  describe 'still_processing?' do
    it 'returns true if the report is still processing' do
      report.status = 'processing'
      expect(report.still_processing?).to be(true)

      report.status = 'pending'
      expect(report.still_processing?).to be(true)
    end

    it 'returns false if the report is not processing' do
      report.status = 'completed'
      expect(report.still_processing?).to be(false)

      report.status = 'failed'
      expect(report.still_processing?).to be(false)
    end
  end

  describe 'ready?' do
    it 'returns true if the report is ready' do
      report.status = 'completed'
      expect(report.ready?).to be(true)

      report.status = 'failed'
      expect(report.ready?).to be(true)
    end

    it 'returns false if the report is not ready' do
      report.status = 'processing'
      expect(report.ready?).to be(false)

      report.status = 'pending'
      expect(report.ready?).to be(false)
    end
  end
end
