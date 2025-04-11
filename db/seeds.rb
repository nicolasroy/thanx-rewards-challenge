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
  r.image = "products/drink.jpg"
  r.content = "Quench your thirst with our signature soft drink—refreshingly crisp and perfectly chilled to complement every meal!"
end

salad = Reward.find_or_create_by!(title: "Poke Salad") do |r|
  r.points = 100
  r.image = "products/poke-salad.jpg"
  r.content = "Indulge in our signature Poke Salad — a refreshing blend of fresh vegetables, delicately cookedegg, and a zesty dressing, all toopped in a crispy seaweed!"
end

Reward.find_or_create_by!(title: "Ramen Soup") do |r|
  r.points = 150
  r.image = "products/ramen-soup.jpg"
  r.content = "Savor our Ramen Soup — a comforting blend of rich broth, noodles, and a variety of vegetables, with a tender meat of your choice!"
end

Reward.find_or_create_by!(title: "Salmon Deluxe Roll") do |r|
  r.points = 1200
  r.image = "products/salmon-deluxe-roll.jpg"
  r.content = "Experience the delicacy of our Salmon Deluxe Roll — generously diced fresh salmon, expertly assembed with a slice of lemon, avocado and served atop a bed of sushi rice, topped with a touch of wasabi and soy sauce!"
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

charlie.orders.build(line_items_attributes: [ itemizable: drink ]).place_order!
charlie.orders.build(line_items_attributes: [ itemizable: salad ]).place_order!
charlie.orders.build(line_items_attributes: [ itemizable: drink ]).place_order!
