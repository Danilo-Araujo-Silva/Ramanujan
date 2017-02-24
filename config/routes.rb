Rails.application.routes.draw do
  root 'public#index'

  resources :segmentations
  resources :contacts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
