# frozen_string_literal: true

class CreateLicenseAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :license_assignments do |t|
      t.belongs_to :account, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
