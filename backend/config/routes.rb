Rails.application.routes.draw do
  namespace "api" do
    namespace "v1" do
      get "/users/:id", to: "users#show"
      get "/signup", to: "users#new"
      post "/signup", to: "users#create"
      get "/users/:id/edit", to: "users#edit"
      patch "/users/:id", to: "users#update"

      get '/verification', to: 'sessions#verification'
      get "/login", to: "sessions#new"
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
    end
  end
end
