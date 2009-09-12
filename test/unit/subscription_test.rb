require 'test_helper'

class SubscriptionTest < ActiveRecord::TestCase
  should_belong_to :user
  should_belong_to :subscriber
  should_validate_presence_of :user_id, :subscriber_id
end
