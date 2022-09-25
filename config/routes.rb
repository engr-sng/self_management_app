Rails.application.routes.draw do

  scope module: :public do
    root to: "homes#top"
    get "/dashboard", to: "users#dashboard", as: "dashboard"
    get "/my_page", to: "users#show", as: "my_page"
    get '/confirm', to: "users#confirm", as: "confirm"
    patch '/deactivate', to: "users#deactivate", as: "deactivate"
    resource :users, only: [:edit, :update]
    post '/my_task_refinement', to: "users#my_task_refinement", as: "my_task_refinement"
    post '/my_project_refinement', to: "users#my_project_refinement", as: "my_project_refinement"

    resources :projects, only: [:show, :new, :create, :edit, :update, :destroy] do
      get '/gantt_chart', to: "projects#gantt_chart", as: "gantt_chart"
      get '/parent_tasks/bulk_new', to: "parent_tasks#bulk_new", as: "parent_task_bulk_new"
      post '/parent_tasks/bulk_create', to: "parent_tasks#bulk_create", as: "parent_task_bulk_create"
      get '/parent_tasks/bulk_delete', to: "parent_tasks#bulk_delete", as: "parent_task_bulk_delete"
      delete '/parent_tasks/bulk_destroy', to: "parent_tasks#bulk_destroy", as: "parent_task_bulk_destroy"
      resources :parent_tasks, only: [:show, :new, :create, :edit, :update, :destroy]
      patch '/child_tasks/:id/select_update', to: "child_tasks#select_update", as: "child_task_select_update"
      get '/child_tasks/bulk_new', to: "child_tasks#bulk_new", as: "child_task_bulk_new"
      post '/child_tasks/bulk_create', to: "child_tasks#bulk_create", as: "child_task_bulk_create"
      get '/child_tasks/bulk_delete', to: "child_tasks#bulk_delete", as: "child_task_bulk_delete"
      delete '/child_tasks/bulk_destroy', to: "child_tasks#bulk_destroy", as: "child_task_bulk_destroy"
      resources :child_tasks, only: [:show, :new, :create, :edit, :update, :destroy]
      resources :project_members, only: [:show, :new, :create, :edit, :update, :destroy]
      resources :documents, only: [:show, :new, :create, :edit, :update, :destroy]
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
    resources :users, only: [:index, :show, :edit, :update]
  end

  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
