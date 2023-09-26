class CreateJoinTableFilersFilings < ActiveRecord::Migration[7.0]
  def change
    create_join_table :filers, :filings do |t|
      t.index :filer_id
    end
  end
end
