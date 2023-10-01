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

ActiveRecord::Schema[7.0].define(version: 2023_09_21_050416) do
  create_table "award_lists", force: :cascade do |t|
    t.integer "filing_id"
    t.integer "recipient_id"
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filing_id"], name: "index_award_lists_on_filing_id"
    t.index ["recipient_id"], name: "index_award_lists_on_recipient_id"
  end

  create_table "filers", force: :cascade do |t|
    t.string "ein", null: false
    t.string "name", null: false
    t.string "address_line_1", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "filings", force: :cascade do |t|
    t.integer "filer_id"
    t.date "tax_period_end_date", null: false
    t.datetime "return_timestamp", precision: nil, null: false
    t.boolean "amended", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filer_id"], name: "index_filings_on_filer_id"
  end

  create_table "recipients", force: :cascade do |t|
    t.string "ein"
    t.string "name", null: false
    t.string "address_line_1", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "award_lists", "filings"
  add_foreign_key "filings", "filers"
end
