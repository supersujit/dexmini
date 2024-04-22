# frozen_string_literal: true

Rails.application.routes.draw do
  get 'scans/index'
  get 'scans/create'
  resources :scans, only: %i[index create]
end
