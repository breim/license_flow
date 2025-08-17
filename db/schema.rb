# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 20_250_817_055_846) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pg_catalog.plpgsql'

  create_table 'accounts', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'license_assignments', force: :cascade do |t|
    t.bigint 'account_id', null: false
    t.bigint 'user_id', null: false
    t.bigint 'product_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_id'], name: 'index_license_assignments_on_account_id'
    t.index ['product_id'], name: 'index_license_assignments_on_product_id'
    t.index ['user_id'], name: 'index_license_assignments_on_user_id'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'name'
    t.text 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'subscriptions', force: :cascade do |t|
    t.bigint 'account_id', null: false
    t.bigint 'product_id', null: false
    t.integer 'number_of_licenses', default: 0
    t.datetime 'issued_at', default: -> { 'CURRENT_TIMESTAMP' }
    t.datetime 'expires_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_id'], name: 'index_subscriptions_on_account_id'
    t.index ['product_id'], name: 'index_subscriptions_on_product_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.bigint 'account_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_id'], name: 'index_users_on_account_id'
    t.index ['email'], name: 'index_users_on_email', unique: true
  end

  add_foreign_key 'license_assignments', 'accounts'
  add_foreign_key 'license_assignments', 'products'
  add_foreign_key 'license_assignments', 'users'
  add_foreign_key 'subscriptions', 'accounts'
  add_foreign_key 'subscriptions', 'products'
  add_foreign_key 'users', 'accounts'
end
