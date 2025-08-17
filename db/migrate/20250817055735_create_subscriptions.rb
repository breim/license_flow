# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :account, null: false, foreign_key: true
      t.belongs_to :product, null: false, foreign_key: true
      t.integer :number_of_licenses, default: 0
      t.datetime :issued_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :expires_at

      t.timestamps
    end
  end
end
