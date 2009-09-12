class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.belongs_to :user
      t.belongs_to :subscriber
    end

    add_index :subscriptions, [:user_id, :subscriber_id]
  end

  def self.down
    remove_index :subscriptions, :column => [:user_id, :subscriber_id]

    drop_table :subscriptions
  end
end
