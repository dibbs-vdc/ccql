Rails.application.routes.draw do
  
  mount Blacklight::Engine => '/'
  
    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, 
             :controllers => { 
               :omniauth_callbacks => 'users/omniauth_callbacks',
               :registrations => "users/registrations"
             }

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

end

Hyrax::Engine.routes.draw do  
  namespace :admin do
    # TODO: Not sure if this is an appropriate route to add...
    post 'pending_registrations/approve_user'
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
