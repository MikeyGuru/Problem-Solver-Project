require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Problem.delete_all
Note.delete_all

2.times do

  fake_name = Faker::Name.name
  user = User.create!(name: fake_name,
                      email: Faker::Internet.free_email(fake_name),
                      password_digest: BCrypt::Password.create("password", cost: 10))

  rand(1..2).times do
    problem = Problem.create!(user: user,
                     issue: Faker::Lorem.sentence(3),
                     try:  Faker::Lorem.sentence(50))
  end
end

fake_name = "Kheang"
user = User.create!(name: fake_name,
                    email: "email@email.com",
                    password_digest: BCrypt::Password.create("password", cost: 10))

rand(2).times do
  problem = Problem.create!(user: user,
                            issue: Faker::Lorem.sentence(3),
                            try:  Faker::Lorem.sentence(50))
end

Problem.all.each do |problem|
  rand(1..2).times do
    problem.notes.create!(user: User.all.sample,
                          comment: Faker::Lorem.sentence(10),
                          chosen: false)
  end
end