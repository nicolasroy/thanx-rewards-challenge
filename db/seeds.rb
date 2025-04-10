# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.production?
  puts "Seed cannot run in production"
  puts "Exiting"
  return
end

puts "Seeding rewards"
drink = Reward.find_or_create_by!(title: "Fountain Drink") do |r|
  r.points = 50
end

salad = Reward.find_or_create_by!(title: "Small salad") do |r|
  r.points = 100
end

Reward.find_or_create_by!(title: "Soup") do |r|
  r.points = 150
end

Reward.find_or_create_by!(title: "Salmon Tartar") do |r|
  r.points = 1200
end

puts "Seeding users"
User.find_or_create_by!(email_address: "alex@thanx.com") do |u|
  u.name = "Alex Admin"
  u.is_admin = true
  u.password = "password"
end

charlie = User.find_or_create_by!(email_address: "charlie@thanx.com") do |u|
  u.name = "Charlie User"
  u.password = "password"
end

charlie.earnings.create! amount: 300
charlie.earnings.create! amount: 100

CreateOrder.call!(order: charlie.orders.build(line_items_attributes: [ itemizable: drink ]))
CreateOrder.call!(order: charlie.orders.build(line_items_attributes: [ itemizable: salad ]))
CreateOrder.call!(order: charlie.orders.build(line_items_attributes: [ itemizable: drink ]))
