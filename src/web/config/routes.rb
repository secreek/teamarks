Web::Application.routes.draw do
  # APIs
  match "/v1/share/" => "urls#share"
  match "/v1/list/"  => "urls#list_urls"
  match "/v1/user/"  => "user#show_user"

  resources :urls

  resources :users
end
