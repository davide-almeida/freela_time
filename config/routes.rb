Rails.application.routes.draw do
  # namespace :app do
  #   get 'dashboard_reports/index'
  # end
  #jobs
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  #default app routes
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
    resources :goals
    resources :dashboard_reports, only: [:index]
    match '/dashboard_reports/print_in_payment_report', to: 'dashboard_reports#print_in_payment_report', via: 'post'
    # get '/dashboard_reports/print_in_payment_report', to: 'dashboard_reports#print_in_payment_report'
    get 'dashboard/filter_dashboard_report_projects_by_company', to: 'dashboard#filter_dashboard_report_projects_by_company'
    resources :users
    resources :settings
    resources :work_groups
    resources :user_contacts, only: [:index]
    match '/user_contacts/destroy_friendship', to: 'user_contacts#destroy_friendship', via: 'post'
  end
  
  #default site routes
  namespace :site do
    root to: 'home#index'
    get 'home', to: 'home#index'
  end

  #devise routes
  # devise_for :users, :skip => [:registrations]
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  devise_scope :user do
    get "/users/sign_out", to: "devise/sessions#destroy"
  end
  
  root to: 'site/home#index'
end
