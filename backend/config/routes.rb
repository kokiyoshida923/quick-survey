Rails.application.routes.draw do
  namespace "api" do
    namespace "v1" do
      get "/users/:id", to: "users#show"
    end
  end
end
