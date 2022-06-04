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

  resources :questions, concerns: :voted do
    resources :answers, concerns: :voted, shallow: true do
      patch :mark_as_best, on: :member
    end
  end

  resources :links, only: :destroy
  resources :attachments, only: :destroy
  resources :rewards, only: :index
end
