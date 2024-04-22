# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Scans', type: :request do
  describe 'GET /index' do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe 'POST /create' do
    let(:file) { fixture_file_upload('robot_scan.json', 'application/json') }
    let(:valid_params) { { scan: { file: } } }
    let(:invalid_params) { { scan: { file: nil } } }

    context 'when valid params are passed' do
      it 'creates a scan' do
        post '/scans', params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Scan created successfully')
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
