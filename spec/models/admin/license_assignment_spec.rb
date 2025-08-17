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
    it {
      should validate_uniqueness_of(:user_id)
        .scoped_to(%i[account_id product_id]).with_message(/already has a license for/)
    }

    context 'license availability' do
      context 'when no subscription exists' do
        let(:account) { create(:account) }
        let(:product) { create(:product) }
        let(:user) { create(:user, account: account) }

        subject { LicenseAssignment.new(account: account, product: product, user: user) }

        it { should_not be_valid }
        it 'has subscription error' do
          subject.valid?
          expect(subject.errors[:base]).to include('No subscription found for this product')
        end
      end

      context 'when no licenses available' do
        let(:account) { create(:account) }
        let(:product) { create(:product) }
        let(:user1) { create(:user, account: account) }

        before do
          create(:subscription, account: account, product: product, number_of_licenses: 1)
          LicenseAssignment.create!(account: account, product: product, user: user1)
        end

        subject { LicenseAssignment.new(account: account, product: product, user: create(:user, account: account)) }

        it { should_not be_valid }
        it 'has no licenses error' do
          subject.valid?
          expect(subject.errors[:base]).to include(/No available licenses for/)
        end
      end
    end
  end

  describe 'class methods' do
    let(:account) { create(:account) }
    let(:product) { create(:product) }
    let(:user1) { create(:user, account: account) }
    let(:user2) { create(:user, account: account) }

    before { create(:subscription, account: account, product: product, number_of_licenses: 10) }

    describe '.create_batch_for_account' do
      let(:params) { { '0' => { user_id: user1.id, product_id: product.id } } }

      it 'creates assignments and returns success hash' do
        result = described_class.create_batch_for_account(account, params)

        expect(result).to include(success: true, errors: [], assignments: be_present)
        expect(result[:assignments].size).to eq(1)
      end

      context 'with invalid data' do
        let(:params) { { '0' => { user_id: user1.id, product_id: create(:product).id } } }

        it 'returns errors for invalid assignments' do
          result = described_class.create_batch_for_account(account, params)

          expect(result[:success]).to be(false)
          expect(result[:errors]).to include('No subscription found for this product')
        end
      end
    end

    describe '.destroy_batch_for_account' do
      let!(:assignment) { create(:license_assignment, account: account, product: product, user: user1) }

      it 'destroys specified assignments' do
        expect do
          described_class.destroy_batch_for_account(account, [user1.id], [product.id])
        end.to change(described_class, :count).by(-1)
      end
    end

    describe '.build_assignments_data' do
      let(:params) { { '0' => { user_id: 123, product_id: 456 } } }

      it 'builds assignment data with account_id' do
        result = described_class.build_assignments_data(account, params)

        expect(result).to eq([{ account_id: account.id, user_id: 123, product_id: 456 }])
      end
    end
  end
end
