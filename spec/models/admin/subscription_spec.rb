# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  subject { build(:subscription) }

  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:product) }
  end

  describe 'validations' do
    it { should validate_presence_of(:account_id) }
    it { should validate_presence_of(:product_id) }
    it { should validate_numericality_of(:number_of_licenses).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:issued_at) }
    it { should validate_presence_of(:expires_at) }
  end
end
