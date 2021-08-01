FactoryBot.define do
  factory :user do
    name { "Example User" }
    email { "user@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :another_user, class: User do
    name { "Another User" }
    email { "another-user@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
