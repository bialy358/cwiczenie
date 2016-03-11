Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  namespace :control_panel do
    root 'boards#index'
    resources :boards do
      resources :stories
      resources :members, expect: [:show, :edit, :update]
    end
  end
end
