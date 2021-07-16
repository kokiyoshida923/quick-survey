Rails.application.routes.draw do
  namespace "api" do
    namespace "v1" do
      get "/users/:id", to: "users#show"
      get "/signup", to: "users#new"
      post "/signup", to: "users#create"
    end
  end
end
