Rails.application.routes.draw do

  scope module: :public do
    root to: "homes#top"
    get "/about", to: "homes#about", as: "about"
    get "/dashboard", to: "users#dashboard", as: "dashboard"
    get "/my_page", to: "users#show", as: "my_page"
    get '/confirm', to: "users#confirm", as: "confirm"
    patch '/deactivate', to: "users#deactivate", as: "deactivate"
    resource :users, only: [:edit, :update]

    resources :projects, only: [:show, :new, :create, :edit, :update, :destroy] do
      resources :parent_tasks, only: [:show,:new, :create,:edit,:update,:destroy]
      resources :child_tasks, only: [:show,:new, :create,:edit,:update,:destroy]
      resources :project_members, only: [:new, :create, :update, :destroy]
    end
  end

  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in', as: "users_guest_sign_in"
  end

  namespace :admin do
    root to: "homes#top"
    resources :users, only: [:index,:show,:edit, :update]
  end

  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
