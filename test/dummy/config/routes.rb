Dummy::Application.routes.draw do
  resources :blogs do
    resources :posts do
      resources :reviews
      resources :comments
    end
  end
  resources :authors
end
