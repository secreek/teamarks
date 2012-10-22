Web::Application.routes.draw do
  # APIs
  match "/v1/share/" => "urls#share"
  match "/v1/list/"  => "urls#list"
  match "/v1/user/"  => "users#show"

  resources :urls

  resources :users
end
