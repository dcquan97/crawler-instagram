User.seed do |s|
  s.id    = 12
  s.email = "asdasd@gmail.com"
  s.username  = "hauyenn"
  s.avatar = Faker::Avatar.image(slug: "my-own-slug", size: "50x50", format: "jpg")
  s.password = "123"
end
