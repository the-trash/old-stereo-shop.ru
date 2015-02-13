# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150213150851) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "assets", force: true do |t|
    t.string   "storage_uid"
    t.string   "storage_name"
    t.integer  "storage_width"
    t.integer  "storage_height"
    t.decimal  "storage_aspect_ratio"
    t.integer  "storage_depth"
    t.string   "storage_format"
    t.string   "storage_mime_type"
    t.string   "storage_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.string   "site_link"
    t.integer  "state",         default: 1
    t.integer  "admin_user_id"
    t.hstore   "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",      default: 0
  end

  add_index "brands", ["admin_user_id"], name: "index_brands_on_admin_user_id", using: :btree
  add_index "brands", ["position"], name: "index_brands_on_position", using: :btree
  add_index "brands", ["slug"], name: "index_brands_on_slug", using: :btree
  add_index "brands", ["state"], name: "index_brands_on_state", using: :btree

  create_table "carts", force: true do |t|
    t.integer  "user_id"
    t.string   "session_token",                                        null: false
    t.decimal  "total_amount",  precision: 10, scale: 2, default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "carts", ["session_token"], name: "index_carts_on_session_token", using: :btree
  add_index "carts", ["user_id"], name: "index_carts_on_user_id", using: :btree

  create_table "characteristic_categories", force: true do |t|
    t.string   "title"
    t.integer  "admin_user_id"
    t.integer  "position",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characteristic_categories", ["admin_user_id"], name: "index_characteristic_categories_on_admin_user_id", using: :btree
  add_index "characteristic_categories", ["position"], name: "index_characteristic_categories_on_position", using: :btree

  create_table "characteristics", force: true do |t|
    t.string   "title"
    t.integer  "position",                   default: 0
    t.integer  "characteristic_category_id"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characteristics", ["characteristic_category_id", "position"], name: "characteristic_category_position", using: :btree
  add_index "characteristics", ["characteristic_category_id"], name: "index_characteristics_on_characteristic_category_id", using: :btree

  create_table "characteristics_products", force: true do |t|
    t.integer "product_id"
    t.integer "characteristic_id"
    t.string  "value"
  end

  add_index "characteristics_products", ["characteristic_id"], name: "index_characteristics_products_on_characteristic_id", using: :btree
  add_index "characteristics_products", ["product_id", "characteristic_id"], name: "composite_product_characteristic", unique: true, using: :btree
  add_index "characteristics_products", ["product_id"], name: "index_characteristics_products_on_product_id", using: :btree

  create_table "cities", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "vk_id"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["region_id"], name: "index_cities_on_region_id", using: :btree
  add_index "cities", ["slug"], name: "index_cities_on_slug", using: :btree
  add_index "cities", ["title"], name: "index_cities_on_title", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "line_items", force: true do |t|
    t.integer "cart_id"
    t.integer "product_id"
    t.integer "order_id"
    t.integer "quantity",   default: 1
  end

  add_index "line_items", ["cart_id", "product_id"], name: "index_line_items_on_cart_id_and_product_id", unique: true, using: :btree
  add_index "line_items", ["cart_id"], name: "index_line_items_on_cart_id", using: :btree
  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id", using: :btree

  create_table "newletters", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "admin_user_id"
    t.integer  "post_category_id"
    t.datetime "last_delivery"
    t.integer  "state",             default: 1
    t.integer  "subscription_type", default: 0
    t.hstore   "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "newletters", ["admin_user_id"], name: "index_newletters_on_admin_user_id", using: :btree
  add_index "newletters", ["post_category_id"], name: "index_newletters_on_post_category_id", using: :btree
  add_index "newletters", ["state"], name: "index_newletters_on_state", using: :btree
  add_index "newletters", ["subscription_type"], name: "index_newletters_on_subscription_type", using: :btree

  create_table "pages", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "short_text"
    t.text     "full_text"
    t.integer  "state",         default: 1
    t.hstore   "meta"
    t.integer  "admin_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["admin_user_id"], name: "index_pages_on_admin_user_id", using: :btree
  add_index "pages", ["slug"], name: "index_pages_on_slug", using: :btree
  add_index "pages", ["state"], name: "index_pages_on_state", using: :btree

  create_table "photos", force: true do |t|
    t.integer  "photoable_id"
    t.string   "photoable_type"
    t.string   "file"
    t.integer  "state",          default: 1
    t.integer  "position",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["photoable_id", "photoable_type", "position"], name: "index_photos_on_photoable_id_and_photoable_type_and_position", using: :btree
  add_index "photos", ["photoable_id", "photoable_type", "state"], name: "index_photos_on_photoable_id_and_photoable_type_and_state", using: :btree
  add_index "photos", ["photoable_id", "photoable_type"], name: "index_photos_on_photoable_id_and_photoable_type", using: :btree

  create_table "post_categories", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.integer  "state",         default: 1
    t.integer  "admin_user_id"
    t.hstore   "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",      default: 0
    t.string   "ancestry"
    t.integer  "depth"
  end

  add_index "post_categories", ["admin_user_id"], name: "index_post_categories_on_admin_user_id", using: :btree
  add_index "post_categories", ["ancestry"], name: "index_post_categories_on_ancestry", using: :btree
  add_index "post_categories", ["position"], name: "index_post_categories_on_position", using: :btree
  add_index "post_categories", ["slug"], name: "index_post_categories_on_slug", using: :btree
  add_index "post_categories", ["state"], name: "index_post_categories_on_state", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.text     "full_text"
    t.integer  "state",            default: 1
    t.integer  "admin_user_id"
    t.integer  "post_category_id"
    t.hstore   "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",         default: 0
  end

  add_index "posts", ["admin_user_id"], name: "index_posts_on_admin_user_id", using: :btree
  add_index "posts", ["position"], name: "index_posts_on_position", using: :btree
  add_index "posts", ["post_category_id"], name: "index_posts_on_post_category_id", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", using: :btree
  add_index "posts", ["state"], name: "index_posts_on_state", using: :btree

  create_table "product_categories", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.integer  "state",                    default: 1
    t.integer  "admin_user_id"
    t.hstore   "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                 default: 0
    t.string   "ancestry"
    t.integer  "depth"
    t.integer  "published_products_count", default: 0
    t.integer  "removed_products_count",   default: 0
    t.integer  "products_count",           default: 0
    t.boolean  "sale",                     default: false
    t.integer  "sale_products_count",      default: 0
  end

  add_index "product_categories", ["admin_user_id"], name: "index_product_categories_on_admin_user_id", using: :btree
  add_index "product_categories", ["ancestry"], name: "index_product_categories_on_ancestry", using: :btree
  add_index "product_categories", ["position"], name: "index_product_categories_on_position", using: :btree
  add_index "product_categories", ["slug"], name: "index_product_categories_on_slug", using: :btree
  add_index "product_categories", ["state"], name: "index_product_categories_on_state", using: :btree

  create_table "product_import_entries", force: true do |t|
    t.integer  "import_id"
    t.string   "state"
    t.text     "import_errors"
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_import_entries", ["import_id", "state"], name: "index_product_import_entries_on_import_id_and_state", using: :btree
  add_index "product_import_entries", ["import_id"], name: "index_product_import_entries_on_import_id", using: :btree
  add_index "product_import_entries", ["state"], name: "index_product_import_entries_on_state", using: :btree

  create_table "product_imports", force: true do |t|
    t.integer  "admin_user_id"
    t.string   "file"
    t.string   "state"
    t.integer  "import_entries_count"
    t.integer  "completed_import_entries_count"
    t.integer  "failed_import_entries_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_imports", ["admin_user_id"], name: "index_product_imports_on_admin_user_id", using: :btree
  add_index "product_imports", ["state"], name: "index_product_imports_on_state", using: :btree

  create_table "products", force: true do |t|
    t.string   "title"
    t.string   "sku"
    t.string   "slug"
    t.text     "description"
    t.integer  "state",                                            default: 1
    t.decimal  "price",                   precision: 10, scale: 2, default: 0.0,  null: false
    t.integer  "discount",                                         default: 0,    null: false
    t.integer  "admin_user_id"
    t.integer  "brand_id"
    t.integer  "product_category_id"
    t.hstore   "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                                         default: 0
    t.integer  "score_weight",                                     default: 5
    t.integer  "average_score",                                    default: 0
    t.integer  "reviews_count",                                    default: 0
    t.integer  "published_reviews_count",                          default: 0
    t.integer  "removed_reviews_count",                            default: 0
    t.integer  "moderated_reviews_count",                          default: 0
    t.boolean  "in_stock",                                         default: true
    t.decimal  "euro_price",              precision: 10, scale: 2, default: 0.0,  null: false
    t.decimal  "euro_rate",               precision: 10, scale: 2, default: 0.0,  null: false
  end

  add_index "products", ["admin_user_id"], name: "index_products_on_admin_user_id", using: :btree
  add_index "products", ["brand_id"], name: "index_products_on_brand_id", using: :btree
  add_index "products", ["position"], name: "index_products_on_position", using: :btree
  add_index "products", ["product_category_id"], name: "index_products_on_product_category_id", using: :btree
  add_index "products", ["slug"], name: "index_products_on_slug", using: :btree
  add_index "products", ["state"], name: "index_products_on_state", using: :btree

  create_table "products_related_products", id: false, force: true do |t|
    t.integer "product_id"
    t.integer "related_product_id"
  end

  add_index "products_related_products", ["product_id"], name: "index_products_related_products_on_product_id", using: :btree
  add_index "products_related_products", ["related_product_id"], name: "index_products_related_products_on_related_product_id", using: :btree

  create_table "products_similar_products", id: false, force: true do |t|
    t.integer "product_id"
    t.integer "similar_product_id"
  end

  add_index "products_similar_products", ["product_id"], name: "index_products_similar_products_on_product_id", using: :btree
  add_index "products_similar_products", ["similar_product_id"], name: "index_products_similar_products_on_similar_product_id", using: :btree

  create_table "products_stores", force: true do |t|
    t.integer "product_id"
    t.integer "store_id"
    t.integer "count",      null: false
  end

  add_index "products_stores", ["product_id", "store_id"], name: "composite_product_store", unique: true, using: :btree
  add_index "products_stores", ["product_id"], name: "index_products_stores_on_product_id", using: :btree
  add_index "products_stores", ["store_id"], name: "index_products_stores_on_store_id", using: :btree

  create_table "ratings", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "user_id"
    t.integer  "score",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree
  add_index "ratings", ["votable_id", "votable_type", "score"], name: "index_ratings_on_votable_id_and_votable_type_and_score", using: :btree
  add_index "ratings", ["votable_id", "votable_type", "user_id"], name: "index_ratings_on_votable_id_and_votable_type_and_user_id", using: :btree
  add_index "ratings", ["votable_id", "votable_type"], name: "index_ratings_on_votable_id_and_votable_type", using: :btree

  create_table "regions", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "vk_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regions", ["slug"], name: "index_regions_on_slug", using: :btree
  add_index "regions", ["title"], name: "index_regions_on_title", using: :btree

  create_table "reviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "rating_id"
    t.text     "body"
    t.string   "pluses"
    t.string   "cons"
    t.integer  "recallable_id"
    t.string   "recallable_type"
    t.integer  "state",           default: 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["rating_id"], name: "index_reviews_on_rating_id", using: :btree
  add_index "reviews", ["recallable_id", "recallable_type", "state"], name: "index_reviews_on_recallable_id_and_recallable_type_and_state", using: :btree
  add_index "reviews", ["recallable_id", "recallable_type"], name: "index_reviews_on_recallable_id_and_recallable_type", using: :btree
  add_index "reviews", ["user_id", "recallable_id", "recallable_type"], name: "index_reviews_on_user_id_and_recallable_id_and_recallable_type", unique: true, using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "settings", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.string   "description"
    t.string   "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", force: true do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key", using: :btree

  create_table "stores", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.string   "latitude"
    t.string   "longitude"
    t.boolean  "happens",       default: true
    t.integer  "state",         default: 1
    t.integer  "position",      default: 0
    t.integer  "admin_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stores", ["admin_user_id"], name: "index_stores_on_admin_user_id", using: :btree
  add_index "stores", ["position"], name: "index_stores_on_position", using: :btree
  add_index "stores", ["slug"], name: "index_stores_on_slug", using: :btree
  add_index "stores", ["state"], name: "index_stores_on_state", using: :btree

  create_table "subscribed_emails", force: true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscribed_emails", ["email"], name: "index_subscribed_emails_on_email", unique: true, using: :btree
  add_index "subscribed_emails", ["user_id"], name: "index_subscribed_emails_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.date     "birthday"
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "full_name"
    t.integer  "reviews_count",          default: 0
    t.integer  "city_id",                default: 0
    t.string   "address"
    t.integer  "index"
    t.hstore   "subscription_settings"
  end

  add_index "users", ["city_id"], name: "index_users_on_city_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wishes", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
