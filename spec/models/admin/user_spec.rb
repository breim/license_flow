# frozen_string_literal: true

# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:account_id) }
  end

  describe 'associations' do
    it { should belong_to(:account) }
  end

  describe 'database indexes' do
    it { should have_db_index(:email).unique(true) }
    it { should have_db_index(:account_id) }
  end
end
