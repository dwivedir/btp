class CreateJoinTableStoreTag < ActiveRecord::Migration
  def change
    create_join_table :stores, :tags do |t|
      # t.index [:store_id, :tag_id]
      # t.index [:tag_id, :store_id]
    end
  end
end
