# frozen_string_literal: true

FactoryBot.define do
  factory :admin_account, class: 'Admin::Account' do
    name { 'MyString' }
  end
end
