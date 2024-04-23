# frozen_string_literal: true

Rails.application.routes.draw do
  get 'comparison_reports/new'
  get 'comparison_reports/show'
  get 'comparison_reports/generate'
  get 'scans/index'
  get 'scans/create'
  resources :scans, only: %i[index create]
  resources :comparison_reports, only: %i[new show] do
    collection do
      post :generate
    end
  end
end
