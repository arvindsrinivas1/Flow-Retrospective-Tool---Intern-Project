Rails.application.routes.draw do

  root 'action_items#index'	
  resources :action_items
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
