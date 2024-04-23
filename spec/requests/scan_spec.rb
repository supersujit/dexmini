# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Scans', type: :request do
  fixtures :scans
  describe 'GET /index' do
    context 'without any scans available' do
      it 'returns http success' do
        get '/scans'
        expect(response).to have_http_status(:success)
        expect(response.body).to include('No Robot Scans have found')
      end
    end

    context 'with scans available' do
      let(:scan) { scans(:one) }
      before do
        scan.update!(status: Scan.statuses[:completed],
                     file: fixture_file_upload('robot_scan.json', 'application/json'))
      end
      it 'returns http success' do
        get '/scans'
        expect(response).to have_http_status(:success)
        expect(response.body).to include(scan.filename)
      end
    end
  end

  describe 'POST /create' do
    let(:file) { fixture_file_upload('robot_scan.json', 'application/json') }
    let(:valid_params) { { scan: { file: } } }
    let(:invalid_params) { { scan: { file: nil } } }

    context 'when valid params are passed' do
      it 'creates a scan' do
        post '/scans', params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Robot Scan created successfully')
      end
    end

    context 'when invalid params are passed' do
      it 'returns http status 422' do
        post '/scans', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to eq(["File can't be blank"])
      end
    end

    context 'when wrong file type is passed' do
      let(:file) { fixture_file_upload('scan.pdf', 'application/pdf') }
      it 'returns http status 422' do
        post '/scans', params: valid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to eq(['File has an invalid content type'])
      end
    end
  end
end
