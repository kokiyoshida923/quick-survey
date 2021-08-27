User.create!(
  name: "Example User",
  email: "user@example.com",
  password: "password",
  password_confirmation: "password"
)

(2..70).each do |n|
  name  = Faker::Internet.username(specifier: 6..20, separators: %w[. _ -])
  email = "user-#{n}@example.com"
  password = "password"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password
  )
end

seed_dir = Rails.root.join("public/seed_#{Rails.env}/").to_s
uploads_dir = Rails.root.join("public/uploads_#{Rails.env}/").to_s
FileUtils.rm_r(seed_dir) if FileTest.exist?(seed_dir)
FileUtils.rm_r(uploads_dir) if FileTest.exist?(uploads_dir)
FileUtils.mkdir_p(seed_dir)

User.all.each do |user|
  seed_avatar_url = Faker::Avatar.image(slug: user.id, format: "jpg").split(/\?/).first
  seed_avatar_file = File.basename(seed_avatar_url)
  seed_avatar_path = seed_dir + seed_avatar_file
  File.open(seed_avatar_path, "wb") do |output|
    URI.parse(seed_avatar_url).open do |data|
      output.write(data.read)
      puts seed_avatar_url
    end
  end

  user.update!(
    avatar: File.open(Rails.root.join(seed_avatar_path))
  )
end
