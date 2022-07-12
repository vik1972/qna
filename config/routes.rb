# frozen_string_literal: true

Rails.application.routes.draw do

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  concern :voted do
    member do
      patch :vote_up
      patch :vote_down
      delete :cancel_vote
    end
  end

  concern :commented do
    resources :comments, shallow: true, only: :create
  end

  resources :questions, concerns: %i[voted commented] do
    resources :answers, concerns: %i[voted commented], shallow: true do
      patch :mark_as_best, on: :member
    end
  end

  concern :commented do
    resources :comments, shallow: true, only: :create
  end

  resources :links, only: :destroy
  resources :attachments, only: :destroy
  resources :rewards, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
