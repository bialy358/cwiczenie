Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  namespace :control_panel do
    root 'boards#index'
    resources :boards do
      resources :members
      resources :stories
    end
  end
end
