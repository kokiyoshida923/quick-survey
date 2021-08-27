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

  factory :users, class: User do
    name { Faker::Internet.unique.username(specifier: 6..20, separators: %w[. _ -]) }
    email { Faker::Internet.unique.email(name: "users") }
    password { "password" }
    password_confirmation { "password" }
  end
end
