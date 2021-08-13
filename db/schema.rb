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

ActiveRecord::Schema.define(version: 2021_08_13_112341) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "by_hours", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.integer "hour_price_cents"
    t.integer "recurrence"
    t.date "start_pay_day"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "start_invoice_day"
    t.index ["project_id"], name: "index_by_hours_on_project_id"
  end

  create_table "by_projects", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.integer "payment_type"
    t.integer "total_value_cents"
    t.integer "total_parcel"
    t.integer "recurrence"
    t.date "start_invoice_day"
    t.date "start_pay_day"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_by_projects_on_project_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "work_group_id"
    t.index ["user_id"], name: "index_companies_on_user_id"
    t.index ["work_group_id"], name: "index_companies_on_work_group_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "goal_in_payments", force: :cascade do |t|
    t.integer "goal_value_cents"
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "goal_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["goal_id"], name: "index_goal_in_payments_on_goal_id"
  end

  create_table "goals", force: :cascade do |t|
    t.string "goal_type"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "in_parcels", force: :cascade do |t|
    t.bigint "in_payment_id", null: false
    t.integer "value_cents"
    t.integer "status"
    t.integer "parcel_number"
    t.date "due_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "invoice_due_date"
    t.date "paid_day"
    t.index ["in_payment_id"], name: "index_in_parcels_on_in_payment_id"
  end

  create_table "in_payments", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_in_payments_on_project_id"
    t.index ["user_id"], name: "index_in_payments_on_user_id"
  end

  create_table "invites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "email"
    t.string "link"
    t.date "due_date"
    t.integer "status"
    t.integer "invite_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "host_invite_id"
    t.index ["user_id"], name: "index_invites_on_user_id"
  end

  create_table "project_storages", force: :cascade do |t|
    t.string "name"
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_project_storages_on_project_id"
    t.index ["user_id"], name: "index_project_storages_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.integer "status"
    t.integer "payment_type"
    t.index ["company_id"], name: "index_projects_on_company_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "theme"
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "task_schedules", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "task_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "work_hour"
    t.index ["task_id"], name: "index_task_schedules_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.integer "status"
    t.index ["company_id"], name: "index_tasks_on_company_id"
    t.index ["project_id"], name: "index_tasks_on_project_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "user_work_groups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "work_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_work_groups_on_user_id"
    t.index ["work_group_id"], name: "index_user_work_groups_on_work_group_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "host_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_groups", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "owner_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "by_hours", "projects"
  add_foreign_key "by_projects", "projects"
  add_foreign_key "companies", "users"
  add_foreign_key "companies", "work_groups"
  add_foreign_key "goal_in_payments", "goals"
  add_foreign_key "goals", "users"
  add_foreign_key "in_parcels", "in_payments"
  add_foreign_key "in_payments", "projects"
  add_foreign_key "in_payments", "users"
  add_foreign_key "invites", "users"
  add_foreign_key "project_storages", "projects"
  add_foreign_key "project_storages", "users"
  add_foreign_key "projects", "companies"
  add_foreign_key "projects", "users"
  add_foreign_key "settings", "users"
  add_foreign_key "task_schedules", "tasks"
  add_foreign_key "tasks", "companies"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "users"
  add_foreign_key "user_work_groups", "users"
  add_foreign_key "user_work_groups", "work_groups"
end
