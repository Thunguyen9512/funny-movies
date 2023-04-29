Rails.application.routes.draw do
  root to: 'movies#index'

  resources :movies, only: %i[new create] do
    collection do
      # for custom route
    end
  end
end