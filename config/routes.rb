Rails.application.routes.draw do
  #jobs
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  Rails.application.routes.draw do
    mount Sidekiq::Web => '/sidekiq'
  end

  #default routes
  namespace :app do
    root to: 'dashboard#index'
    get 'dashboard', to: 'dashboard#index'
    get 'dashboard/filter_projects_by_company', to: 'dashboard#filter_projects_by_company'
    get 'dashboard/filter_tasks_by_project', to: 'dashboard#filter_tasks_by_project'
    match '/dashboard/create_task_scheduler', to: 'dashboard#create', via: 'post'
    
    resources :tasks do
      resources :task_schedules
      put 'change_status', to: 'change_status'
    end
    resources :companies
    resources :projects do
      put 'change_status', to: 'change_status'
    end
    get 'task_select/filter_projects_by_company' => 'tasks#filter_projects_by_company'
    resources :in_payments do
      resources :in_parcels do
        put 'change_status', to: 'change_status'
      end
    end
    resources :project_storages
  end
  
  namespace :site do
    root to: 'home#index'
    get 'home', to: 'home#index'
  end

  #devise
  devise_for :users#, :skip => [:registrations]
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  
  root to: 'site/home#index'
end
