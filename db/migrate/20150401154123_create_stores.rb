class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.boolean :public
      t.string :filename
      t.string :location
      t.integer :user_id

      t.timestamps
    end
  end
end
