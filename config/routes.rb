# == Route Map
#
#                                 Prefix Verb   URI Pattern                                                       Controller#Action
#                       new_user_session GET    /users/sign_in(.:format)                                          devise/sessions#new
#                           user_session POST   /users/sign_in(.:format)                                          devise/sessions#create
#                   destroy_user_session DELETE /users/sign_out(.:format)                                         devise/sessions#destroy
#                      new_user_password GET    /users/password/new(.:format)                                     devise/passwords#new
#                     edit_user_password GET    /users/password/edit(.:format)                                    devise/passwords#edit
#                          user_password PATCH  /users/password(.:format)                                         devise/passwords#update
#                                        PUT    /users/password(.:format)                                         devise/passwords#update
#                                        POST   /users/password(.:format)                                         devise/passwords#create
#                               ckeditor        /ckeditor                                                         Ckeditor::Engine
#                            sidekiq_web        /sidekiq                                                          Sidekiq::Web
#                             live_event GET    /events/:id/live(.:format)                                        events#live
#                         validate_event GET    /events/:id/validate(.:format)                                    events#validate
#                           ticket_event GET    /events/:id/ticket(.:format)                                      events#ticket
#                       mailtester_event GET    /events/:id/mailtester(.:format)                                  events#mailtester
#                    do_mailtester_event POST   /events/:id/do_mailtester(.:format)                               events#do_mailtester
#                       print_list_event GET    /events/:id/print_list(.:format)                                  events#print_list
#                          checkin_event GET    /events/:id/checkin(.:format)                                     events#checkin
#                 send_invitations_event POST   /events/:id/send_invitations(.:format)                            events#send_invitations
#         check_invitations_status_event POST   /events/:id/check_invitations_status(.:format)                    events#check_invitations_status
#                   send_test_mail_event POST   /events/:id/send_test_mail(.:format)                              events#send_test_mail
#                       import_csv_event GET    /events/:id/import_csv(.:format)                                  events#import_csv
#                       export_csv_event GET    /events/:id/export_csv(.:format)                                  events#export_csv
#                    export_failed_event GET    /events/:id/export_failed(.:format)                               events#export_failed
#                    do_import_csv_event POST   /events/:id/do_import_csv(.:format)                               events#do_import_csv
#         send_invitation_event_attendee POST   /events/:event_id/attendees/:id/send_invitation(.:format)         attendees#send_invitation
# check_invitation_status_event_attendee POST   /events/:event_id/attendees/:id/check_invitation_status(.:format) attendees#check_invitation_status
#                  ticket_event_attendee GET    /events/:event_id/attendees/:id/ticket(.:format)                  attendees#ticket
#                    logs_event_attendee GET    /events/:event_id/attendees/:id/logs(.:format)                    attendees#logs
#                 checkin_event_attendee GET    /events/:event_id/attendees/:id/checkin(.:format)                 attendees#checkin
#                        event_attendees GET    /events/:event_id/attendees(.:format)                             attendees#index
#                                        POST   /events/:event_id/attendees(.:format)                             attendees#create
#                     new_event_attendee GET    /events/:event_id/attendees/new(.:format)                         attendees#new
#                    edit_event_attendee GET    /events/:event_id/attendees/:id/edit(.:format)                    attendees#edit
#                         event_attendee GET    /events/:event_id/attendees/:id(.:format)                         attendees#show
#                                        PATCH  /events/:event_id/attendees/:id(.:format)                         attendees#update
#                                        PUT    /events/:event_id/attendees/:id(.:format)                         attendees#update
#                                        DELETE /events/:event_id/attendees/:id(.:format)                         attendees#destroy
#                       event_categories GET    /events/:event_id/categories(.:format)                            categories#index
#                                        POST   /events/:event_id/categories(.:format)                            categories#create
#                     new_event_category GET    /events/:event_id/categories/new(.:format)                        categories#new
#                    edit_event_category GET    /events/:event_id/categories/:id/edit(.:format)                   categories#edit
#                         event_category GET    /events/:event_id/categories/:id(.:format)                        categories#show
#                                        PATCH  /events/:event_id/categories/:id(.:format)                        categories#update
#                                        PUT    /events/:event_id/categories/:id(.:format)                        categories#update
#                                        DELETE /events/:event_id/categories/:id(.:format)                        categories#destroy
#                                 events GET    /events(.:format)                                                 events#index
#                                        POST   /events(.:format)                                                 events#create
#                              new_event GET    /events/new(.:format)                                             events#new
#                             edit_event GET    /events/:id/edit(.:format)                                        events#edit
#                                  event GET    /events/:id(.:format)                                             events#show
#                                        PATCH  /events/:id(.:format)                                             events#update
#                                        PUT    /events/:id(.:format)                                             events#update
#                                        DELETE /events/:id(.:format)                                             events#destroy
#                           mg_delivered POST   /mg/delivered(.:format)                                           mg#webhook
#                             mg_dropped POST   /mg/dropped(.:format)                                             mg#webhook
#                             mg_bounced POST   /mg/bounced(.:format)                                             mg#webhook
#                                  users GET    /users(.:format)                                                  users#index
#                                        POST   /users(.:format)                                                  users#create
#                               new_user GET    /users/new(.:format)                                              users#new
#                              edit_user GET    /users/:id/edit(.:format)                                         users#edit
#                                   user GET    /users/:id(.:format)                                              users#show
#                                        PATCH  /users/:id(.:format)                                              users#update
#                                        PUT    /users/:id(.:format)                                              users#update
#                                        DELETE /users/:id(.:format)                                              users#destroy
#                                   root GET    /                                                                 static#index
#                          configuration GET    /configuration(.:format)                                          static#configuration
#                       example_validate GET    /example_validate(.:format)                                       static#example_validate
#
# Routes for Ckeditor::Engine:
#         pictures GET    /pictures(.:format)             ckeditor/pictures#index
#                  POST   /pictures(.:format)             ckeditor/pictures#create
#          picture DELETE /pictures/:id(.:format)         ckeditor/pictures#destroy
# attachment_files GET    /attachment_files(.:format)     ckeditor/attachment_files#index
#                  POST   /attachment_files(.:format)     ckeditor/attachment_files#create
#  attachment_file DELETE /attachment_files/:id(.:format) ckeditor/attachment_files#destroy
#

Rails.application.routes.draw do
  devise_for :users, skip: [:registration]

  mount Ckeditor::Engine => '/ckeditor'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :events do
    member do
      get 'live', as: 'live'
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
        get 'checkin', as: 'checkin'
      end
    end
    resources :categories
  end

  post 'mg/delivered' => 'mg#webhook'
  post 'mg/dropped' => 'mg#webhook'
  post 'mg/bounced' => 'mg#webhook'

  resources :users

  root 'static#index'

  get 'configuration', to: 'static#configuration', as: 'configuration'
  get 'example_validate', to: 'static#example_validate', as: 'example_validate'
end
