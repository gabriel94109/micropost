BasicApp::Application.routes.draw do
  resources :users, :except => [ :new, :create ]
  resources :microblogs do
    collection do
      get :read
    end
  end
  resources :comments, :path => :microposts, :except => [ :edit, :update, :destroy ] do
    member do
      get :vote 
      post :reply
    end
  end

  # signin/out
  match '/auth/twitter/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'
  match '/signin', :to => 'sessions#signin', :as => :signin
  match "/signout" => "sessions#destroy", :as => :signout 

  # site
  match '/contact', :to => 'site_pages#contact'
  match '/about', :to => 'site_pages#about'
  match '/help', :to => 'site_pages#help'
  match '/links', :to => 'site_pages#links'
  match '/sitemap', :to => 'sitemap#index', :via => [:get]

  match '/:name', :to => 'users#show'
  #root :to => "site_pages#home"
  root :to => "comments#index"
end
