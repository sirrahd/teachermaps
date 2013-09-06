Teachermaps::Application.routes.draw do


  resources :settings

  resources :sessions, only: [:new, :create, :destroy]
  resources :feedbacks, only: [:create]

  root to: 'static_pages#home'

  match '/404',  to: 'static_pages#page404', as: 'page404'
  match '/500',  to: 'static_pages#page500', as: 'page500'

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new', :as => 'signin'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/privacy', to: 'static_pages#privacy'
  match '/terms',   to: 'static_pages#tos'

  match '/robots.txt', to: 'static_pages#robots'

  match '/confirm',         to: 'users#confirm_email'
  match '/reset',           to: 'users#reset_password'
  match '/update_password', to: 'users#update_password'

  match '/subscribe/email' => 'mail_chimp#subscribe'

  # Sync Google Drive and/or DropBox resources
  match '/resources/sync' => 'resources#sync'
  match '/resources/create/link' => 'resources#create_link'
  match '/resources/create/link/form' => 'resources#create_link_form', as: 'create_link_form'
  match '/resources/filter' => 'resources#filter'
  match '/resources/page' => 'resources#page'
  resources :resources

  match 'users/:user_id/resources' => 'resources#index', :as => 'show_resources'
  resources :users do
    resources :maps
    resources :map_standards, :path => 'standards', only: [:show]
  end

  resources :map_resources

  resources :maps, only: [:update, :create, :destroy]
  resources :maps do
    resources :map_standards, only: [:create]
    resources :share_email, only: [:create]
    post 'sort_assessments'
    post 'sort_standards'
    post 'privacy_state'
  end
  resources :maps, only: [:show]

  resources :map_standards, only: [:update, :destroy]
  resources :map_standards do
    post 'sort_objectives'
  end

  resources :map_assessments do
    member do
      get    'show_resources'
      post   'filter_resources'
      post   'create_resource'
      delete 'destroy_resource'
      post   'sort_resources'
    end
  end

  resources :map_objectives do
    member do
      get    'show_resources'
      post   'filter_resources'
      post   'create_resource'
      delete 'destroy_resource'
      post   'sort_resources'
    end
  end

  match '/standards/ajax/filter' => 'standards#ajax_filter'
  resources :standards

  # Google API
  match 'google/oauth_callback' => 'google_accounts#oauth_callback'
  resources :google_accounts

  # DropBox API
  match 'dropbox/new' => 'drop_box_accounts#new', :as => 'new_drop_box_accounts'
  match 'dropbox/preview/:path' => 'drop_box_accounts#preview', :as => 'drop_box_accounts_preview', :constraints => {:path => /[\w.\/]+/}
  match 'dropbox/oauth_callback' => 'drop_box_accounts#oauth_callback'
  resources :drop_box_accounts


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
