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

ActiveRecord::Schema.define(version: 2019_02_26_154210) do

  create_table "active_admin_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "input_matrix_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "is_directed_graph"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "request_id"
    t.index ["request_id"], name: "index_input_matrix_requests_on_request_id"
  end

  create_table "open_street_map_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "min_longitude"
    t.string "min_latitude"
    t.string "max_longitude"
    t.string "max_latitude"
    t.string "osm_response_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "request_id"
    t.index ["request_id"], name: "index_open_street_map_requests_on_request_id"
  end

  create_table "open_street_map_requests_tag_infos", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "open_street_map_request_id", null: false
    t.bigint "tag_info_id", null: false
    t.index ["open_street_map_request_id", "tag_info_id"], name: "index_osm_request_id_and_tag_info_id"
  end

  create_table "requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "request_type"
    t.string "algorithm_type"
    t.text "odr_api_matrix", limit: 4294967295
    t.integer "odr_api_path_length"
    t.integer "odr_api_number_resources"
    t.boolean "odr_api_cycles"
    t.string "odr_api_uuid"
    t.text "solution", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tag_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tag_key"
    t.string "tag_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "input_matrix_requests", "requests", on_delete: :cascade
  add_foreign_key "open_street_map_requests", "requests", on_delete: :cascade
end
