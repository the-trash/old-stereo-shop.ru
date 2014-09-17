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

ActiveRecord::Schema.define(version: 20140917102517) do

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
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

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

  create_table "post_categories", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.integer  "state",         default: 1
    t.integer  "admin_user_id"
    t.hstore   "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "depth"
  end

  add_index "post_categories", ["admin_user_id"], name: "index_post_categories_on_admin_user_id", using: :btree
  add_index "post_categories", ["ancestry"], name: "index_post_categories_on_ancestry", using: :btree
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
    t.integer  "state",         default: 1
    t.integer  "admin_user_id"
    t.hstore   "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "depth"
  end

  add_index "product_categories", ["admin_user_id"], name: "index_product_categories_on_admin_user_id", using: :btree
  add_index "product_categories", ["ancestry"], name: "index_product_categories_on_ancestry", using: :btree
  add_index "product_categories", ["slug"], name: "index_product_categories_on_slug", using: :btree
  add_index "product_categories", ["state"], name: "index_product_categories_on_state", using: :btree

  create_table "products", force: true do |t|
    t.string   "title"
    t.string   "sku"
    t.string   "slug"
    t.text     "description"
    t.integer  "state",                                        default: 1
    t.decimal  "price",               precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "discount",            precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "admin_user_id"
    t.integer  "brand_id"
    t.integer  "product_category_id"
    t.hstore   "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                                     default: 0
  end

  add_index "products", ["admin_user_id"], name: "index_products_on_admin_user_id", using: :btree
  add_index "products", ["brand_id"], name: "index_products_on_brand_id", using: :btree
  add_index "products", ["position"], name: "index_products_on_position", using: :btree
  add_index "products", ["product_category_id"], name: "index_products_on_product_category_id", using: :btree
  add_index "products", ["slug"], name: "index_products_on_slug", using: :btree
  add_index "products", ["state"], name: "index_products_on_state", using: :btree

  create_table "settings", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.string   "description"
    t.string   "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
