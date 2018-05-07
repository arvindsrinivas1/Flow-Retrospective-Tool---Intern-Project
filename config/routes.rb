Rails.application.routes.draw do

  resources :teams
  root 'teams#index'	
  resources :action_items
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
