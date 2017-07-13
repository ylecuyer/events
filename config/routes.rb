Rails.application.routes.draw do

  devise_for :users, skip: [:registration]

  mount Ckeditor::Engine => '/ckeditor'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :events do
    member do
      get 'validate', as: 'validate'
      get 'ticket', as: 'ticket'

      get 'mailtester', as: 'mailtester'
      post 'do_mailtester', as: 'do_mailtester'

      get 'print_list', as: 'print_list'
      get 'checkin', as: 'checkin'
      post 'send_invitations', as: 'send_invitations'
      post 'check_invitations_status', as: 'check_invitations_status'
      post 'send_test_mail', as: 'send_test_mail'
      get 'import_csv', as: 'import_csv'
      get 'export_csv', as: 'export_csv'
      get 'export_failed', as: 'export_failed'
      post 'do_import_csv', as: 'do_import_csv'
    end
    resources :attendees do
      member do
        post 'send_invitation', as: 'send_invitation'
        post 'check_invitation_status', as: 'check_invitation_status'
        get 'ticket', as: 'ticket'
        get 'logs', as: 'logs'
      end
    end
    resources :categories
  end

  post 'mg/delivered' => 'mg#webhook'
  post 'mg/dropped' => 'mg#webhook'
  post 'mg/bounced' => 'mg#webhook'

  resources :users

  root "static#index"

  get 'configuration', to: 'static#configuration', as: 'configuration'
  get 'example_validate', to: 'static#example_validate', as: 'example_validate'

end
