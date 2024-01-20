Rails.application.routes.draw do
  devise_for :users

  root 'home#index'

  get 'member/:id', to: 'members#show', as: 'member'

  get 'edit_description', to: 'members#edit_description', as: 'edit_member_description'

  patch 'update_description', to: 'members#update_description', as: 'update_member_description'

  get 'edit_details', to: "members#edit_details", as: 'edit_member_details'

  patch 'update_details', to: 'members#update_details', as: 'update_member_details'

  resources :work_experiences
end
