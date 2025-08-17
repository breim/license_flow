# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    name { Faker::Company.name }
  end

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    association :account
  end

  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
  end

  factory :subscription do
    association :account
    association :product
    number_of_licenses { Faker::Number.between(from: 1, to: 100) }
    issued_at { Faker::Time.between(from: 1.year.ago, to: Time.current) }
    expires_at { Faker::Time.between(from: Time.current, to: 2.years.from_now) }
  end

  factory :license_assignment do
    association :account
    association :user
    association :product

    after(:build) do |license_assignment|
      create(:subscription,
             account: license_assignment.account,
             product: license_assignment.product,
             number_of_licenses: 10)
    end
  end
end
