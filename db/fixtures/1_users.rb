User.seed do |s|
  s.id    = 3
  s.email = "dcqbean@gmail.com"
  s.username  = "maikk.phan"
  s.avatar = Faker::Avatar.image(slug: "my-own-slug", size: "50x50", format: "jpg")
  s.password = "123"
end

