class CreateFilings < ActiveRecord::Migration[6.0]
  def change
    create_table :filings do |t|
      t.belongs_to :filer, index: true, foreign_key: true
      t.date :tax_period_end_date, null: false
      t.datetime :return_timestamp, null: false
      t.boolean :amended, default: false

      t.timestamps
    end
  end
end
