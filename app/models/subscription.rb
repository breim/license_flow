# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :account
  belongs_to :product

  validates :account_id, :product_id, :issued_at, :expires_at, presence: true
  validates :number_of_licenses, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
