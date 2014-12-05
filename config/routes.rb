Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Allow devise to map routes to controllers, but skipping the default controllers., :skip => [:sessions, :registrations]
  devise_for :clients, :skip => [:sessions, :registrations, :confirmations, :passwords]
  devise_for :admins, :skip => [:sessions, :registrations, :confirmations, :passwords]
  devise_for :company_users, :skip => [:sessions, :registrations, :confirmations, :passwords]
  
  # Maps all authorization custom routes to devise default controllers.
  devise_scope :user do
    post '/sign_in' => 'authorization#login'
    delete '/sign_out' => 'authorization#logout'
    post '/sign_up' => 'authorization#sign_up'
    post '/recover' => 'authorization#recover'
  end

  # API defined in its own namespace, so all routes with the '/api/' prefix are handled
  # outside AngularJS.
  namespace :api, :defaults => {:format => :json} do
    resources :empresa, :rubro, :cuenta, :pago, :account, :except => [:edit, :new]
    get 'accounts/:account', to: 'bank_account#show', as: 'accounts'
    post 'transfer/', to: 'bank_account#transfer'
    post 'multi_transfer/', to: 'bank_account#multi_transfer'
  end

  # Root has higher priority than our forwarding route.
  root 'application#index'
  # This route redirects all unknown paths to the root route. From there, AngularJS uses its own router.
  get '*path' => 'application#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
