class CreateAwardLists < ActiveRecord::Migration[7.0]
  def change
    create_table :award_lists do |t|
      t.belongs_to :filing, index: true, foreign_key: true
      t.belongs_to :recipient

      t.integer :amount, null: false

      t.timestamps
    end
  end
end
