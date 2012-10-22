Web::Application.routes.draw do
  match "/v1/share/" => "urls#share"

  resources :urls

  resources :users
end
