class ChangeMoods < ActiveRecord::Migration
  def self.up
    remove_column :moods, :name

    add_column :moods, :red, :integer
    add_column :moods, :green, :integer
    add_column :moods, :blue, :integer
    add_index :moods, [:red, :green, :blue]
  end

  def self.down
    remove_index :moods, :column => [:red, :green, :blue]
    remove_column :moods, :blue
    remove_column :moods, :green
    remove_column :moods, :red

    add_column :moods, :name, :string
    add_index :moods, :name
  end
end
