class CreateFilers < ActiveRecord::Migration[7.0]
  def change
    create_table :filers do |t|
      t.string :ein, null: false
      t.string :name, null: false
      t.string :address_line_1, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false

      t.timestamps
    end
  end
end
