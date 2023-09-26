class CreateJoinTableAwardListsRecipients < ActiveRecord::Migration[7.0]
  def change
    create_join_table :award_lists, :recipients
  end
end
