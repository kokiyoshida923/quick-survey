Rails.application.routes.draw do
  namespace "api" do
    namespace "v1" do
      get "/users/:id", to: "users#show"
      get "/signup", to: "users#new"
      post "/signup", to: "users#create"

      get '/verification', to: 'sessions#verification'
      get "/login", to: "sessions#new"
      post "/login", to: "sessions#create"
    end
  end
end
