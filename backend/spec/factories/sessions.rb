FactoryBot.define do
  factory :unauthenticated_user, class: Session do
    email { "user@example.com" }
    password { "password" }
  end
end
