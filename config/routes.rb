# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

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


  mount ActionCable.server => '/cable'
end
