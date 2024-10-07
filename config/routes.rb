Rails.application.routes.draw do
  devise_for :users,
             controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations'
             }
  get '/test', to: 'test#show'
  
  namespace :api do
    namespace :v1 do
      resources :dreams do
        resources :interpretations
        get 'search', on: :collection
      end
    end
  end
end