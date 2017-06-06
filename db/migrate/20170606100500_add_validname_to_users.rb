class AddValidnameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :validname, :string
    add_index :users, :validname, unique: true
  end
end
