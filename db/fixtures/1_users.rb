User.seed do |s|
  s.id    = 1
  s.email = "jon@example.com"
  s.username  = "jon"
  s.avatar = Faker::Avatar.image(slug: "my-own-slug", size: "50x50", format: "jpg")
end

User.seed do |s|
  s.id    = 2
  s.email = "emily@example.com"
  s.username  = "emily"
  s.avatar = Faker::Avatar.image(slug: "my-own-slug", size: "50x50", format: "jpg")
end
