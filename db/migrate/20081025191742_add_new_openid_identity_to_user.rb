class AddNewOpenidIdentityToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :new_openid_identity, :string
  end

  def self.down
    remove_column :users, :new_openid_identity
  end
end
