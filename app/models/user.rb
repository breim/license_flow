# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :account

  validates :email, presence: true, uniqueness: true
  validates :account_id, presence: true
  validates :name, presence: true
end
