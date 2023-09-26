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

ActiveRecord::Schema[7.0].define(version: 2023_09_21_050653) do
  create_table "award_lists", force: :cascade do |t|
    t.string "filing_id", null: false
    t.string "filer_id", null: false
    t.string "recipient_id", null: false
    t.integer "amount", null: false
    t.boolean "amended", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "award_lists_recipients", id: false, force: :cascade do |t|
    t.integer "award_list_id", null: false
    t.integer "recipient_id", null: false
  end

  create_table "filers", force: :cascade do |t|
    t.string "filing_id", null: false
    t.string "ein", null: false
    t.string "name", null: false
    t.string "address_line_1", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "filers_filings", id: false, force: :cascade do |t|
    t.integer "filer_id", null: false
    t.integer "filing_id", null: false
    t.index ["filer_id"], name: "index_filers_filings_on_filer_id"
  end

  create_table "filings", force: :cascade do |t|
    t.string "filer_id", null: false
    t.date "tax_period_end_date", null: false
    t.datetime "return_timestamp", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipients", force: :cascade do |t|
    t.string "award_list_id", null: false
    t.string "ein", null: false
    t.string "name", null: false
    t.string "address_line_1", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
