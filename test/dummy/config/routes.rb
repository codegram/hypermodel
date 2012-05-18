Dummy::Application.routes.draw do
  resources :posts do
    resources :reviews
  end
  resources :authors
end
