Rails.application.routes.draw do
  post 'agreement_letters/create'
  get 'agreement_letters/show'

  resources :requests
  resources :application_letters, path: 'applications' do
    resources :application_notes,
      only: :create
  end
  resources :events do
    resources :agreement_letters, only: [:create], shallow: true
    get 'badges'
    post 'badges' => 'events#print_badges', as: :print_badges
  end
  resources :profiles
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get 'events/:id/participants' => 'events#participants'
  get 'events/:id/send-acceptance-emails' => 'events#send_acceptance_emails', as: :event_send_acceptance_emails
  get 'events/:id/send-rejection-emails' => 'events#send_rejection_emails', as: :event_send_rejection_emails

  post 'send_email' => 'emails#send_email'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
