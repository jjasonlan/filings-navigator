class CreateFilings < ActiveRecord::Migration[6.0]
  def change
    create_table :filings do |t|
      t.string :filer_id, null: false
      t.date :tax_period_end_date, null: false
      t.datetime :return_timestamp, null: false

      t.timestamps
    end
  end
end
