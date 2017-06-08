class AddJingToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :jing, :boolean, :default => false
  end
end
