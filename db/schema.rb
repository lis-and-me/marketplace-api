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

ActiveRecord::Schema[8.1].define(version: 2026_07_29_043259) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "alias", null: false
    t.string "city", null: false
    t.string "country", null: false
    t.datetime "created_at", null: false
    t.string "external_number", null: false
    t.string "internal_number"
    t.boolean "is_default", default: false, null: false
    t.string "neighborhood", null: false
    t.string "postal_code", null: false
    t.string "recipient", null: false
    t.text "references"
    t.string "state", null: false
    t.string "street", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "audit_logs", force: :cascade do |t|
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.jsonb "new_values", default: {}
    t.jsonb "old_values", default: {}
    t.bigint "record_id", null: false
    t.string "table_name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "brands", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id", "product_id"], name: "index_cart_items_on_cart_id_and_product_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
    t.check_constraint "quantity > 0", name: "cart_items_quantity_check"
    t.check_constraint "unit_price >= 0::numeric", name: "cart_items_price_check"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_carts_on_user_id", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.bigint "parent_id"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "coupons", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.integer "discount_type", null: false
    t.datetime "expires_at"
    t.decimal "minimum_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "starts_at"
    t.datetime "updated_at", null: false
    t.integer "usage_limit"
    t.integer "used_count", default: 0, null: false
    t.decimal "value", precision: 10, scale: 2, null: false
    t.index ["code"], name: "index_coupons_on_code", unique: true
  end

  create_table "inventory_movements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "movement_type", null: false
    t.string "note"
    t.bigint "order_id"
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.integer "stock_after", null: false
    t.integer "stock_before", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_inventory_movements_on_order_id"
    t.index ["product_id"], name: "index_inventory_movements_on_product_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.string "product_name"
    t.string "product_sku"
    t.integer "quantity", null: false
    t.decimal "subtotal", precision: 10, scale: 2, null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
    t.check_constraint "quantity > 0", name: "order_items_quantity_check"
    t.check_constraint "subtotal >= 0::numeric", name: "order_items_subtotal_check"
    t.check_constraint "unit_price >= 0::numeric", name: "order_items_price_check"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "address_id", null: false
    t.bigint "coupon_id"
    t.datetime "created_at", null: false
    t.decimal "discount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "shipping", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "tax", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["address_id"], name: "index_orders_on_address_id"
    t.index ["coupon_id"], name: "index_orders_on_coupon_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
    t.check_constraint "discount >= 0::numeric", name: "orders_discount_check"
    t.check_constraint "shipping >= 0::numeric", name: "orders_shipping_check"
    t.check_constraint "subtotal >= 0::numeric", name: "orders_subtotal_check"
    t.check_constraint "tax >= 0::numeric", name: "orders_tax_check"
    t.check_constraint "total >= 0::numeric", name: "orders_total_check"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "MXN", null: false
    t.jsonb "metadata", default: {}, null: false
    t.bigint "order_id", null: false
    t.datetime "paid_at"
    t.integer "payment_method", default: 0, null: false
    t.integer "provider", null: false
    t.string "provider_payment_id"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["provider_payment_id"], name: "index_payments_on_provider_payment_id", unique: true
  end

  create_table "product_categories", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["product_id", "category_id"], name: "index_product_categories_on_product_id_and_category_id", unique: true
    t.index ["product_id"], name: "index_product_categories_on_product_id"
  end

  create_table "product_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "image_url", null: false
    t.integer "position", default: 1, null: false
    t.bigint "product_id", null: false
    t.string "public_id"
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.decimal "average_rating", precision: 3, scale: 2, default: "0.0", null: false
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description", null: false
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "reviews_count", default: 0, null: false
    t.string "sku", null: false
    t.string "slug", null: false
    t.integer "stock", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["slug"], name: "index_products_on_slug", unique: true
    t.check_constraint "price >= 0::numeric", name: "products_price_check"
    t.check_constraint "stock >= 0", name: "products_stock_check"
  end

  create_table "ratings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.integer "score", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["product_id"], name: "index_ratings_on_product_id"
    t.index ["user_id", "product_id"], name: "index_ratings_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_ratings_on_user_id"
    t.check_constraint "score >= 1 AND score <= 5", name: "ratings_score_check"
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.boolean "revoked", default: false, null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["token"], name: "index_refresh_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment", null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.bigint "rating_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["product_id"], name: "index_reviews_on_product_id"
    t.index ["rating_id"], name: "index_reviews_on_rating_id"
    t.index ["user_id", "product_id"], name: "index_reviews_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "email", null: false
    t.datetime "email_verified_at"
    t.datetime "last_login_at"
    t.string "last_name", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "phone"
    t.integer "role", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "suspended_until"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "wishlist_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["product_id"], name: "index_wishlist_items_on_product_id"
    t.index ["user_id", "product_id"], name: "index_wishlist_items_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_wishlist_items_on_user_id"
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "users"
  add_foreign_key "categories", "categories", column: "parent_id", on_delete: :nullify
  add_foreign_key "inventory_movements", "orders"
  add_foreign_key "inventory_movements", "products"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "addresses"
  add_foreign_key "orders", "coupons"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "product_categories", "categories"
  add_foreign_key "product_categories", "products"
  add_foreign_key "product_images", "products"
  add_foreign_key "products", "brands"
  add_foreign_key "ratings", "products"
  add_foreign_key "ratings", "users"
  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "ratings"
  add_foreign_key "reviews", "users"
  add_foreign_key "wishlist_items", "products"
  add_foreign_key "wishlist_items", "users"
end
