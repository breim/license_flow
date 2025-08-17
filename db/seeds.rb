# frozen_string_literal: true

puts '🌱 Starting seeding process...'

if Rails.env.development?
  puts '🧹 Cleaning existing data...'
  LicenseAssignment.destroy_all
  Subscription.destroy_all
  User.destroy_all
  Account.destroy_all
  Product.destroy_all
end

puts '📦 Creating products...'
products = [
  {
    name: 'Office Suite Pro',
    description: 'Complete office productivity suite with word processing, spreadsheets, and presentations'
  },
  {
    name: 'Design Studio Ultimate',
    description: 'Professional graphic design software for creative professionals'
  },
  {
    name: 'Analytics Dashboard',
    description: 'Advanced business intelligence and data visualization platform'
  },
  {
    name: 'Project Manager Enterprise',
    description: 'Comprehensive project management and team collaboration tool'
  },
  {
    name: 'Security Shield',
    description: 'Enterprise-grade cybersecurity and threat protection solution'
  }
]

created_products = products.map do |product_data|
  product = Product.find_or_create_by!(name: product_data[:name]) do |p|
    p.description = product_data[:description]
  end
  puts "  ✅ Created product: #{product.name}"
  product
end

puts '🏢 Creating companies...'
companies = [
  {
    name: 'TechCorp Solutions',
    description: 'Leading technology solutions provider'
  },
  {
    name: 'Digital Innovations Ltd',
    description: 'Digital transformation specialists'
  },
  {
    name: 'Global Systems Inc',
    description: 'Multinational systems integration company'
  }
]

created_accounts = companies.map do |company_data|
  account = Account.find_or_create_by!(name: company_data[:name])
  puts "  ✅ Created company: #{account.name}"
  account
end

puts '👥 Creating users...'
users_per_company = [4, 3, 3]

created_accounts.each_with_index do |account, index|
  user_count = users_per_company[index]

  user_count.times do |_i|
    user = User.find_or_create_by!(
      email: Faker::Internet.unique.email(domain: "#{account.name.downcase.delete(' ')}.com")
    ) do |u|
      u.name = Faker::Name.name
      u.account = account
    end
    puts "  ✅ Created user: #{user.name} (#{user.email}) for #{account.name}"
  end
end

puts '📋 Creating subscriptions...'
subscription_configs = [
  { account_index: 0, product_indices: [0, 1, 2], licenses: [15, 10, 8] },
  { account_index: 1, product_indices: [1, 3], licenses: [12, 6] },
  { account_index: 2, product_indices: [0, 2, 3, 4], licenses: [20, 15, 10, 5] }
]

created_subscriptions = []
subscription_configs.each do |config|
  account = created_accounts[config[:account_index]]

  config[:product_indices].each_with_index do |product_index, i|
    product = created_products[product_index]
    license_count = config[:licenses][i]

    subscription = Subscription.find_or_create_by!(
      account: account,
      product: product
    ) do |s|
      s.number_of_licenses = license_count
      s.issued_at = Faker::Time.between(from: 6.months.ago, to: 1.month.ago)
      s.expires_at = Faker::Time.between(from: 6.months.from_now, to: 2.years.from_now)
    end

    created_subscriptions << subscription
    puts "  ✅ Created subscription: #{account.name} → #{product.name} (#{license_count} licenses)"
  end
end

puts '🎫 Creating license assignments...'
created_subscriptions.each do |subscription|
  account = subscription.account
  product = subscription.product
  users = account.users.to_a

  assign_count = [subscription.number_of_licenses * 0.6, users.count].min.to_i
  assigned_users = users.sample(assign_count)

  assigned_users.each do |user|
    LicenseAssignment.find_or_create_by!(
      account: account,
      user: user,
      product: product
    )
    puts "  ✅ Assigned #{product.name} license to #{user.name} (#{account.name})"
  rescue ActiveRecord::RecordInvalid => e
    puts "  ⚠️ Skipped assignment (#{e.message})"
  end
end

puts "\n📊 Seeding Summary:"
puts "  Companies: #{Account.count}"
puts "  Products: #{Product.count}"
puts "  Users: #{User.count}"
puts "  Subscriptions: #{Subscription.count}"
puts "  License Assignments: #{LicenseAssignment.count}"

puts "\n📈 License Usage by Company:"
Account.includes(:subscriptions, :license_assignments).each do |account|
  puts "\n  #{account.name}:"
  account.subscriptions.includes(:product).each do |subscription|
    used_licenses = account.license_assignments.where(product: subscription.product).count
    puts "    #{subscription.product.name}: #{used_licenses}/#{subscription.number_of_licenses} licenses used"
  end
end

puts "\n🎉 Seeding completed successfully!"
