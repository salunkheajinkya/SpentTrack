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

ActiveRecord::Schema[8.0].define(version: 2026_11_22_044948) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "account_type", null: false
    t.string "institution"
    t.decimal "opening_balance", precision: 15, scale: 2, default: "0.0", null: false
    t.string "currency", default: "INR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_type"], name: "index_accounts_on_account_type"
    t.index ["name"], name: "index_accounts_on_name"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "category_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "category_type"], name: "index_categories_on_name_and_category_type", unique: true
  end

  create_table "statement_imports", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "filename", null: false
    t.string "status", default: "pending", null: false
    t.integer "total_rows", default: 0, null: false
    t.integer "imported_rows", default: 0, null: false
    t.integer "duplicate_rows", default: 0, null: false
    t.integer "failed_rows", default: 0, null: false
    t.jsonb "error_details", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_statement_imports_on_account_id"
    t.index ["status"], name: "index_statement_imports_on_status"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "category_id"
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.date "transaction_date", null: false
    t.string "description"
    t.string "merchant"
    t.string "transaction_type", null: false
    t.string "reference_number"
    t.string "external_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "statement_import_id"
    t.index ["account_id", "external_id"], name: "index_transactions_on_account_id_and_external_id", unique: true, where: "(external_id IS NOT NULL)"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["statement_import_id"], name: "index_transactions_on_statement_import_id"
    t.index ["transaction_date"], name: "index_transactions_on_transaction_date"
    t.index ["transaction_type"], name: "index_transactions_on_transaction_type"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "statement_imports", "accounts"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transactions", "statement_imports"
end
