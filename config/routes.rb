Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  namespace :admin do
    root 'static_pages#index'
  end
end
