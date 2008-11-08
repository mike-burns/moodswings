class CreateMood < ActiveRecord::Migration
  def self.up
    create_table :moods do |t|
      t.string :name
      t.belongs_to :user

      t.timestamps
    end

    add_index :moods, :name
    add_index :moods, :user_id
  end

  def self.down
    remove_index :moods, :column => :user_id
    remove_index :moods, :column => :name

    drop_table :moods
  end
end
