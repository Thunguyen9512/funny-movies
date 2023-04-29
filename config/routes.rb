Rails.application.routes.draw do
  devise_for :users
  root to: 'movies#index'

  resources :movies, only: %i[new create] do
    collection do
      post :like
      post :dislike
      # for custom route
    end
  end
end