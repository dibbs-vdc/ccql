Rails.application.routes.draw do
  
  mount Blacklight::Engine => '/'
  
    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, skip: [:registrations],
             controllers: { :omniauth_callbacks => 'users/omniauth_callbacks',
                            :registrations => "users/registrations" }

  # Only allow new/create/cancel for new user registrations
  as :user do
    get   "/users/sign_up" => "users/registrations#new", :as => :new_user_registration
    post  "/user" => "users/registrations#create", :as => :user_registration
    get   "/users/cancel" => "users/registrations#cancel", :as => :cancel_user_registration
  end

  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  curation_concerns_embargo_management
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  match "/download_cv/:id/", :controller => "hyrax/admin/users", :action => "download_cv", via: :get

end


Hyrax::Engine.routes.draw do  
  namespace :admin do
    # TODO: Not sure if this is an appropriate route to add...
    post 'pending_registrations/approve_user'
    post 'pending_registrations/update_person'
    post 'pending_registrations/create_person'
    resources :pending_registrations, only: [:index]
    resources :users
  end

  if Rails.env.development?
    namespace :admin do
      namespace :vdc do
        resources :people  
      end
    end
  end
end
