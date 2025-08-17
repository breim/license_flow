# frozen_string_literal: true

class LicenseAssignment < ApplicationRecord
  belongs_to :account
  belongs_to :user
  belongs_to :product

  validates :account_id, :user_id, :product_id, presence: true
  validate :license_availability
  validates_uniqueness_of :user_id, scope: %i[account_id product_id], message: lambda { |object, _data|
    "#{object.user&.name} (#{object.user&.email}) already has a license for #{object.product&.name}"
  }

  def self.create_batch_for_account(account, assignments_params)
    assignments_data = build_assignments_data(account, assignments_params)
    results = assignments_data.map { |data| new(data) }
                              .partition(&:save)

    created, failed = results
    errors = failed.flat_map { |a| a.errors.full_messages }.uniq

    { success: errors.empty?, errors: errors, assignments: created }
  end

  def self.destroy_batch_for_account(account, user_ids, product_ids)
    where(
      account_id: account.id,
      user_id: user_ids,
      product_id: product_ids
    ).destroy_all
  end

  def self.build_assignments_data(account, assignments_params)
    assignments_params.values.map do |assignment_data|
      {
        account_id: account.id,
        user_id: assignment_data[:user_id],
        product_id: assignment_data[:product_id]
      }
    end
  end

  private

  def license_availability
    return unless account && product

    subscription = account.subscriptions.find_by(product: product)
    return errors.add(:base, 'No subscription found for this product') unless subscription

    return unless subscription.available_licenses < 1

    errors.add(:base, "No available licenses for #{product.name}")
  end
end
