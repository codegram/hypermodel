Dummy::Application.routes.draw do
  resources :blogs do
    resources :posts do
      resources :reviews
    end
  end
  resources :authors
end
