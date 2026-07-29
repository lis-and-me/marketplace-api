Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post :login,    to: "sessions#create"
        post :refresh,  to: "refresh_tokens#create"
        delete :logout, to: "refresh_tokens#destroy"
        post :register, to: "registrations#create"
      end
      resource :cart, only: [:show], controller: :cart do
  post "items", to: "cart#add_item"
  patch "items/:id", to: "cart#update_item"
  delete "items/:id", to: "cart#remove_item"
end
       
post "assistant/chat", to: "assistant#chat"
      resource :profile, only: :show

      resources :addresses

      resources :wishlist, only: %i[
        index
        create
        destroy
      ]
resources :products, only: %i[index show] do
  resources :reviews, only: %i[index create]
end

resources :reviews, only: %i[
  show
  update
  destroy
]

resources :categories, only: %i[index show]
resources :brands, only: %i[index show]

   resources :orders, only: %i[index show] do
  collection do
    post :checkout
  end
end

      resources :products, only: %i[index show]
resources :categories, only: %i[index show]
resources :brands, only: %i[index show]

      namespace :admin do
        post "ai/chat", to: "ai#chat"
        resources :inventory_movements,
          only: %i[index show create]
        resource :dashboard, only: :show, controller: :dashboard
        resources :brands
        resources :categories

        resources :products do
          resources :images,
                    controller: "product_images",
                    only: %i[create update destroy]
        end

        resources :coupons

        resources :users, only: %i[index show update destroy]
        resources :orders, only: %i[index show update]

      resources :reviews, only: %i[
  index
  show
  destroy
] do
  collection do
    get :stats
  end

  member do
    patch :approve
    patch :reject
  end
end
      end
    end
  end
end