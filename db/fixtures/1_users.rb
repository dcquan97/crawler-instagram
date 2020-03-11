User.seed do |s|
  s.id    = 5
  s.email = "dcqbean3@gmail.com"
  s.username  = "chanhh_iichii"
  s.avatar = Faker::Avatar.image(slug: "my-own-slug", size: "50x50", format: "jpg")
  s.password = "123"
end

