require 'faker'

# Destroy all the objects before running the seed to prevent duplication
puts "Destroy everything"

# Reordered these by association because seed failing.
Perk.destroy_all
Purchase.destroy_all
Product.destroy_all
Employee.destroy_all
Business.destroy_all
BusinessCategory.destroy_all
User.destroy_all

# User faker to create the name then split the name into the first_name and last_name attributes.
name = Faker::FunnyName.unique.two_word_name
first_name = name.split(' ')[0]
last_name = name.split(' ')[1]

# Here we seed the database with a 'Genesis' entity in each table, using standard user so we don't have to signup every time we drop the
puts "Creating network bootstrap objects (Czeckpass)"

  name = Faker::FunnyName.unique.two_word_name
  first_name = name.split(' ')[0]
  last_name = name.split(' ')[1]

  user = User.create!(
    email: Faker::Internet.unique.email,
    first_name: first_name,
    last_name: last_name,
     password: '1234567'
    )

  BusinessCategory.create!(
    name: Faker::Company.industry
    )

  business = Business.create!(
    name: Faker::Company.unique.name,
    description: Faker::Company.bs,
    user_id: user.id,
    logo: Faker::Company.logo,
    location: Faker::Address.unique.city,
    business_category: BusinessCategory.last
    )

  Employee.create!(
    business_id: business.id,
    roles: Faker::Company.profession,
    user_id: user.id
    )

  new_products_array = []
  rand(1..10).times do
    product = Product.create!(
        name: Faker::Appliance.equipment ,
        description: Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false),
        price_cents: Faker::Number.number(digits: 5),
        category: Faker::Job.field ,
        business_id: business.id
       )
    new_products_array << product
  end

  Purchase.create!(
    verified: [true, false].sample,
    expiration_date: Date.today + rand(1..30),
    user_id: user.id,
    product_id: new_products_array.sample.id
    )


# to seed the file 10 times we need a ruby loop. We use the faker gem (required above)
puts "10 times ruby loop for users, businesses, products and perks"
10.times do
  name = Faker::FunnyName.unique.two_word_name
  first_name = name.split(' ')[0]
  last_name = name.split(' ')[1]

  user = User.create!(
    email: Faker::Internet.unique.email,
    first_name: first_name,
    last_name: last_name,
     password: '1234567'
    )

  BusinessCategory.create!(
    name: Faker::Company.industry
    )

  business = Business.create!(
    name: Faker::Company.unique.name,
    description: Faker::Company.bs,
    user_id: user.id,
    logo: Faker::Company.logo,
    location: Faker::Address.unique.city,
    business_category: BusinessCategory.last
    )

  Employee.create!(
    business_id: business.id,
    roles: Faker::Company.profession,
    user_id: user.id
    )

  new_products_array = []
  rand(1..10).times do
    product = Product.create!(
        name: Faker::Appliance.equipment ,
        description: Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false),
        price_cents: Faker::Number.number(digits: 5),
        category: Faker::Job.field ,
        business_id: business.id
       )
    new_products_array << product
  end

  Purchase.create!(
    verified: [true, false].sample,
    expiration_date: Date.today + rand(1..30),
    user_id: user.id,
    product_id: new_products_array.sample.id
    )

  providing_business = Business.find(business.id - 1)


  new_products_array.each do |product|
    perk = Perk.new(
      receiving_product_id: product.id,
      kind: ["percentage", "dollars", "non-monetary"].sample,
      amount: rand(1..50),
      description: Faker::Vehicle.manufacture,
      providing_business_id: providing_business ? providing_business.id : czekpass.id,
      providing_product_id: providing_business.products.sample.id,
    )

    perk.save!
  end
end

# We then create a user and an admin for our own test purposes

puts "Create users for Czekpass developers"

czekpass_employees = ['Myles', 'Nick', 'Amir', 'Alex']
who_is_seeder = 3 # Use reference to create the seeds
businesses = Business.all

czekpass_user = User.create!(
  email: "#{czekpass_employees[who_is_seeder].downcase}@czekpass.com",
  first_name: czekpass_employees[who_is_seeder],
  last_name: "Czekpass",
  password: '1234567'
)

rand(1..5).times do
  Purchase.create!(
    verified: [true, false].sample,
    expiration_date: Date.today + rand(1..30),
    user_id: czekpass_user.id,
    product_id: businesses.sample.products.sample.id
    )
end

# Creates a Czekpass admin user with a business

czekpass_admin = User.create!(
  email: "#{czekpass_employees[who_is_seeder].downcase}.admin@czekpass.com",
  first_name: czekpass_employees[who_is_seeder],
  last_name: "Czekpass Admin",
  password: '1234567',
  admin: true
)

czekpass_admin_business = Business.create!(
  name: Faker::Company.unique.name,
  description: Faker::Company.bs,
  user_id: czekpass_admin.id,
  logo: Faker::Company.logo,
  location: Faker::Address.unique.city,
  business_category: BusinessCategory.last
)

czekpass_admin_business_products_array = []

rand(1..10).times do
  product = Product.create!(
    name: Faker::Appliance.equipment ,
    description: Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false),
    price_cents: Faker::Number.number(digits: 5),
    category: Faker::Job.field,
    business_id: czekpass_admin_business.id
  )

  czekpass_admin_business_products_array << product
end

czekpass_admin_business_products_array.each do |product|

  rand(1..10).times do

    providing_business = businesses.sample

    Perk.create!(
      kind: ["percentage", "dollars", "non-monetary"].sample,
      amount: rand(1..50),
      description: Faker::Vehicle.manufacture,
      providing_business_id: providing_business.id,
      providing_product_id: providing_business.products.sample.id,
      receiving_product_id: product.id,
    )
  end

end
