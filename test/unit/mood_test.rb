require 'test_helper'

class MoodTest < ActiveSupport::TestCase
  context "a Mood" do
    subject { Factory(:mood) }

    should_have_db_column :red, :type => 'integer'
    should_have_db_column :green, :type => 'integer'
    should_have_db_column :blue, :type => 'integer'
    should_have_db_column :user_id, :type => 'integer'

    should_belong_to :user
    should_validate_presence_of :red, :green, :blue, :user_id
  end
end
