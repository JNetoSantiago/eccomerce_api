# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.delete_all
User.delete_all
Category.delete_all

3.times do
  Category.create!(
    description: Faker::Commerce.department,
    status: 1
  )
end

3.times do
  User.create!(
    email: Faker::Internet.email,
    password: 'locadexxx1234'
  )
end

12.times do
  Product.create!(
    title: Faker::Commerce.product_name,
    published: true,
    price: Faker::Commerce.price(range: 1.0..100.0),
    user: User.order('RANDOM()').first,
    category: Category.order('RANDOM()').first
  )
end
