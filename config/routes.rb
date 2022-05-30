Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  resources :questions do
    resources :answers, shallow: true do
      patch :mark_as_best, on: :member
    end
  end
  resources :links, only: :destroy
  resources :attachments, only: :destroy
  resources :rewards, only: :index
end
