class CreateUser < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :openid_identity, :nickname, :location, :timezone
      t.timestamps
    end

    add_index :users, :openid_identity
  end

  def self.down
    remove_index :users, :column => :openid_identity

    drop_table :users
  end
end
