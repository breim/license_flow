# frozen_string_literal: true

class LicenseAssignment < ApplicationRecord
  belongs_to :account
  belongs_to :user
  belongs_to :product

  validates :account_id, :user_id, :product_id, presence: true
end
