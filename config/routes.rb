Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  namespace :control_panel do
    root 'static_pages#index'
  end
end
