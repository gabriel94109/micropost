class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :birthname
      t.string :location
      t.string :website
      t.string :bio
      t.string :image
      t.boolean :admin, :default => false

      t.integer :microposts_count, :default =>0
      t.integer :microblogs_count, :default =>0
      t.timestamps
    end
    add_index :users, :microposts_count
    add_index :users, :microblogs_count
  end

  def self.down
    drop_table :users
  end
end
