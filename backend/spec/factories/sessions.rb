FactoryBot.define do
  factory :unauth_user, class: Session do
    email { "user@example.com" }
    password { "password" }
  end
end
