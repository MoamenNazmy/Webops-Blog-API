Rails.application.routes.draw do
  post '/signup', to: 'auth#signup'
  post '/login', to: 'auth#login'
  resources :posts do 
    member do 
      patch :update_tags
    end
    resources :comments 
  end
end
