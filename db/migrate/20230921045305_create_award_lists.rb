class CreateAwardLists < ActiveRecord::Migration[7.0]
  def change
    create_table :award_lists do |t|
      t.string :filing_id, null: false
      t.string :filer_id, null: false
      t.string :recipient_id, null: false
      t.integer :amount, null: false
      t.boolean :amended, null: false

      t.timestamps
    end
  end
end
