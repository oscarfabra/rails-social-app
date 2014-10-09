# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Creates an admin user
User.create!(
  name: "Example User", 
  email: "user@example.org", 
  password: "foobarbaz", 
  password_confirmation: "foobarbaz", 
  admin: true,
  activated: true, 
  activated_at: Time.zone.now)

# Creates 99 non-admin, activated users
99.times do |n|
  name = Faker::Name.name
  email = "user-#{n + 1}@example.org"
  password = "password#{n + 1}"
  User.create!(
    name: name, 
    email: email, 
    password: password, 
    password_confirmation: password, 
    activated: true, 
    activated_at: Time.zone.now)
end

# Creates 3 additional non-activated users
for n in 100..102
  name = Faker::Name.name
  email = "user-#{n}@example.org"
  password = "password#{n}"
  User.create!(
    name: name, 
    email: email, 
    password: password, 
    password_confirmation: password, 
    activated: false)
end

# Adds microposts to the first 6 created users
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
