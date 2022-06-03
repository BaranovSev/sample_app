class AddIndexToUsersEmail < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :email, unique: true 
    # add index for email in table users / set email unique true (on DB level)
  end
end
