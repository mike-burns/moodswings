class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscriber, :class_name => 'User'
  validates_presence_of :user_id, :subscriber_id
end
