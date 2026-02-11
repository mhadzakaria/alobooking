
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :appointments, only: [ :create ]
    end
  end

  get "/booking", to: "bookings#index"
end
