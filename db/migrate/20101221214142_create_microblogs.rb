class CreateMicroblogs < ActiveRecord::Migration
  def self.up
    create_table :microblogs do |t|
      t.string :title
      t.string :keywords
      t.text :content
      t.text :markdown
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :microblogs
  end
end
