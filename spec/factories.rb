# frozen_string_literal: true

FactoryBot.define do
  factory :license_assignment do
    account { nil }
    user { nil }
    product { nil }
  end

  factory :subscription do
    account { nil }
    product { nil }
    number_of_licenses { 1 }
    issued_at { '2025-08-17 07:57:35' }
    expires_at { '2025-08-17 07:57:35' }
  end

  factory :product do
    name { 'MyString' }
    description { 'MyText' }
  end

  factory :account do
    name { Faker::Company.name }
  end
end
