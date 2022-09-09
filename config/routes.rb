Rails.application.routes.draw do

  scope module: :public do
    root to: "homes#top"
    get "/about", to: "homes#about", as: "about"
    get "/dashboard", to: "homes#dashboard", as: "dashboard"
    resources :users, only: [:edit, :update]
    resources :projects, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      resources :milestones, only: [:show]
      resources :parent_tasks, only: [:show]
      resources :child_tasks, only: [:show]
      resources :project_members, only: [:new,:create,:update,:destroy]
    end
  end

  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  namespace :admin do
    root to: "homes#top"
  end

  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
