Teachermaps::Application.routes.draw do

    
  resources :settings

  resources :sessions, only: [:new, :create, :destroy]
  resources :feedbacks, only: [:create]

  root to: 'static_pages#home'

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new', :as => 'signin'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

  match '/confirm', to: 'users#confirm_email'
  match '/reset', to: 'users#reset_password'

  resources :map_standards, only: [:update, :destroy]
  resources :maps, only: [:update, :create, :destroy]
  resources :maps do
    resources :map_standards, only: [:create]
  end

  resources :users do
    resources :maps
    resources :map_standards, :path => 'standards', only: [:show]
  end

  # Sync Google Drive and/or DropBox resources
  match '/resources/sync' => 'resources#sync', :as => 'sync_resources'
  match '/resources/ajax/create/link' => 'resources#ajax_upload_link'
  match '/resources/ajax/show/:slug' => 'resources#ajax_show', :as => 'resources_ajax_show'
  match '/resources/ajax/filter' => 'resources#ajax_filter', :as => 'resources_ajax_filter'
  resources :resources
  
  match '/ajax/map_assessments/:id/resources/filter' => 'map_assessments#ajax_filter_resources', as: 'map_assessment_resources_ajax_filter'
  match '/ajax/map_assessments/:map_assessment_id/map_resources/:resource_id/new' => 'map_assessments#ajax_new_resource', as: 'map_assessments_ajax_new_resource'
  match '/ajax/map_assessments/:map_assessment_id/map_resources/:resource_id/destroy' => 'map_assessments#ajax_destroy_resource', as: 'map_assessments_ajax_destroy_resource'
  resources :map_assessments do
    member do
      get 'show_resources'
      post 'filter_resources'
    end
  end
  resources :map_resources

  
  match '/map_objectives/:map_objective_id/resources/:resource_id/new' => 'map_objectives#create_resource', as: 'map_objectives_create_resource'
  match '/map_objectives/:map_objective_id/resources/:resource_id/destroy' => 'map_objectives#destroy_resource', as: 'map_objectives_destroy_resource'
  match '/map_objectives/:map_objective_id/resources/filter' => 'map_objectives#filter_resources', as: 'map_objectives_resources_filter'
  match '/map_objectives/:map_objective_id/resources/' => 'map_objectives#show_resources', as: 'map_objectives_show_resources'
  resources :map_objectives


  # match '/maps/ajax/filter' => 'map_standards#ajax_filter'
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
