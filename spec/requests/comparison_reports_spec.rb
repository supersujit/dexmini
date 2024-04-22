# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ComparisonReports', type: :request do
  fixtures :scans

  let(:scan) { scans(:one) }
  before do
    scan.update(file: fixture_file_upload('robot_scan.json', 'application/json'), status: :completed)
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/comparison_reports/new', params: { scan_id: scan.id }
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Create Comparison report')
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/comparison_reports/show'
      expect(response).to have_http_status(:success)
    end
  end
end
