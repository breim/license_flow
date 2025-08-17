# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LicenseAssignment, type: :model do
  subject { create(:license_assignment) }

  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:product) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:account_id) }
    it { should validate_presence_of(:product_id) }
    it { should validate_presence_of(:user_id) }
  end
end
