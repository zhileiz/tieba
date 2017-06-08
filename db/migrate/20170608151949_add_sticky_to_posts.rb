class AddStickyToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sticky, :boolean, :default => false
  end
end
